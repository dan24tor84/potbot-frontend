import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import multer from 'multer';
import fetch from 'node-fetch';

const app = express();
const upload = multer({ storage: multer.memoryStorage() });

// ---------- CORS ----------
const allowed = process.env.CORS_ORIGIN?.split(',').map(s => s.trim()).filter(Boolean);
app.use(cors({
  origin: allowed && allowed.length ? allowed : true, // allow specific origins or all in dev
  credentials: false
}));

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// ---------- Helpers ----------
function requireEnv(name) {
  const v = process.env[name];
  if (!v || !v.trim()) throw new Error(`Missing required env var: ${name}`);
  return v.trim();
}

const PORT = Number(process.env.PORT || 3000);

// ---------- Health ----------
app.get('/api/health', (_req, res) => {
  res.json({ ok: true, service: 'potbot-backend', time: new Date().toISOString() });
});

// ---------- Analyze (multipart: field "image") ----------
app.post('/api/analyze', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ ok: false, error: 'Missing file field "image".' });
    }

    // Required keys (already in your Railway/ENV)
    const replicateToken = requireEnv('REPLICATE_API_TOKEN');
    const model = process.env.REPLICATE_MODEL || 'yorickvp/llava-13b';
    const version = process.env.REPLICATE_VERSION || ''; // optional pin

    // Convert to data URL for models that accept base64 images
    const base64 = req.file.buffer.toString('base64');
    const dataUrl = `data:${req.file.mimetype};base64,${base64}`;

    // Prompt tailored to your needs — adjust as you like
    const prompt =
      "Analyze this cannabis bud image for quality risks and visual traits. " +
      "Return JSON with keys: moldRisk (0-1), powderyMildewRisk (0-1), " +
      "trichomeScore (0-10), structureScore (0-10), trimScore (0-10), " +
      "densityScore (0-10), overall (0-100), notes (string). " +
      "Be concise and only output JSON.";

    // Create prediction
    const createBody = version
      ? { version, input: { image: dataUrl, prompt }, model }
      : { input: { image: dataUrl, prompt }, model };

    const createResp = await fetch('https://api.replicate.com/v1/predictions', {
      method: 'POST',
      headers: {
        'Authorization': `Token ${replicateToken}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(createBody)
    });

    if (!createResp.ok) {
      const text = await createResp.text();
      return res.status(502).json({ ok: false, stage: 'create', error: text });
    }

    const prediction = await createResp.json();
    const predUrl = `https://api.replicate.com/v1/predictions/${prediction.id}`;

    // Poll
    let status = prediction.status;
    let result = prediction;
    const started = Date.now();
    const timeoutMs = Number(process.env.REPLICATE_TIMEOUT_MS || 120000); // 120s default

    while (status === 'starting' || status === 'processing') {
      if (Date.now() - started > timeoutMs) {
        return res.status(504).json({ ok: false, error: 'AI timeout' });
      }
      await new Promise(s => setTimeout(s, 1500));
      const pr = await fetch(predUrl, {
        headers: { 'Authorization': `Token ${replicateToken}` }
      });
      if (!pr.ok) {
        const t = await pr.text();
        return res.status(502).json({ ok: false, stage: 'poll', error: t });
      }
      result = await pr.json();
      status = result.status;
    }

    if (status !== 'succeeded') {
      return res.status(502).json({ ok: false, status, error: result?.error || 'AI failed' });
    }

    // Replicate output varies by model; try to parse JSON if present
    let parsed = null;
    try {
      if (typeof result.output === 'string') {
        parsed = JSON.parse(result.output);
      } else if (Array.isArray(result.output) && typeof result.output[0] === 'string') {
        // some models return an array of strings
        parsed = JSON.parse(result.output.join('\n'));
      } else if (typeof result.output === 'object') {
        parsed = result.output;
      }
    } catch (_) {
      // not valid JSON; pass-through
    }

    return res.json({
      ok: true,
      model,
      status,
      result: parsed ?? result.output ?? result
    });

  } catch (err) {
    console.error(err);
    return res.status(500).json({ ok: false, error: String(err) });
  }
});

// ---------- Start ----------
app.listen(PORT, () => {
  console.log(`PotBot backend listening on port ${PORT}`);
});
