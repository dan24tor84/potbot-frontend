// backend/server.js
require("dotenv").config();
const express = require("express");
const cors = require("cors");
const multer = require("multer");
const axios = require("axios");

const app = express();

// --- config ---
const PORT = process.env.PORT || 8080;
const REPLICATE_TOKEN = process.env.REPLICATE_API_TOKEN;
const REPLICATE_MODEL = process.env.REPLICATE_MODEL;        // e.g. "owner/model"
const REPLICATE_VERSION = process.env.REPLICATE_VERSION;    // version hash

// CORS + JSON
app.use(cors({ origin: true }));
app.use(express.json({ limit: "25mb" }));
app.use(express.urlencoded({ extended: true, limit: "25mb" }));

// Multer (memory) – works for file uploads from mobile
const upload = multer({ storage: multer.memoryStorage() });

// Health check
app.get("/health", (_req, res) => res.json({ ok: true }));

/**
 * POST /api/analyze
 * Accepts:
 *  - multipart/form-data with field "image" (mobile)  OR
 *  - JSON body { image_base64: "<BASE64>" } (web)
 * Returns: the Replicate prediction output.
 */
app.post("/api/analyze", upload.single("image"), async (req, res) => {
  try {
    if (!REPLICATE_TOKEN || !REPLICATE_MODEL || !REPLICATE_VERSION) {
      return res.status(500).json({
        error:
          "Server missing REPLICATE_* env vars. Set REPLICATE_API_TOKEN, REPLICATE_MODEL and REPLICATE_VERSION in Railway.",
      });
    }

    // 1) get image bytes from either multipart file or base64 in JSON
    let imageBuffer = null;

    if (req.file && req.file.buffer) {
      imageBuffer = req.file.buffer; // from mobile (MultipartFile.fromPath)
    } else if (req.body && req.body.image_base64) {
      imageBuffer = Buffer.from(req.body.image_base64, "base64"); // from web
    }

    if (!imageBuffer) {
      return res.status(400).json({
        error:
          "No image provided. Send 'image' as multipart file or 'image_base64' in JSON.",
      });
    }

    // 2) turn into data URI – many Replicate models accept this directly
    const dataUri = `data:image/jpeg;base64,${imageBuffer.toString("base64")}`;

    // 3) kick off Replicate prediction
    const create = await axios.post(
      "https://api.replicate.com/v1/predictions",
      {
        version: REPLICATE_VERSION,
        input: {
          // IMPORTANT: change 'image' to the model's input key if different
          image: dataUri,
          // ...add any model-specific inputs here...
        },
      },
      {
        headers: {
          Authorization: `Token ${REPLICATE_TOKEN}`,
          "Content-Type": "application/json",
        },
      }
    );

    // 4) poll until complete
    let getUrl = create.data?.urls?.get;
    if (!getUrl) {
      return res
        .status(500)
        .json({ error: "Replicate response missing polling URL." });
    }

    let status = create.data.status;
    let output = null;
    let tries = 0;

    while (status === "starting" || status === "processing") {
      await new Promise((r) => setTimeout(r, 1500));
      const poll = await axios.get(getUrl, {
        headers: { Authorization: `Token ${REPLICATE_TOKEN}` },
      });
      status = poll.data.status;
      output = poll.data.output;
      if (++tries > 120) break; // ~3min safety
    }

    if (status !== "succeeded") {
      return res.status(502).json({
        error: "Prediction failed or timed out",
        status,
      });
    }

    // 5) send back model output (shape depends on model)
    return res.json({ status, output });
  } catch (err) {
    console.error(err?.response?.data || err.message);
    return res.status(500).json({
      error: "Server error",
      details: err?.response?.data || err.message,
    });
  }
});

app.listen(PORT, () => {
  console.log(`PotBot backend running on :${PORT}`);
});
