// server.js (root)
const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 8080;
const WEB_ROOT = path.join(__dirname, "build", "web");

// 1) Serve index.html with *no cache* so new builds take effect immediately
app.get(["/", "/index.html"], (_req, res) => {
  res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
  res.sendFile(path.join(WEB_ROOT, "index.html"));
});

// 2) Serve all other static assets with cache (fast + CDN-friendly)
app.use(express.static(WEB_ROOT, { maxAge: "7d", immutable: true }));

// 3) SPA fallback — send index.html for client-side routes
app.get("*", (_req, res) => {
  res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
  res.sendFile(path.join(WEB_ROOT, "index.html"));
});

app.listen(PORT, () => {
  console.log(`✅ PotBot web listening on :${PORT}`);
});
