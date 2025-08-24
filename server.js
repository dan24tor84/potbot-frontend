const express = require("express");
const path = require("path");
const app = express();

const PORT = process.env.PORT || 8080;
const WEB_ROOT = path.join(__dirname, "build", "web");

// Long-cache static assets
app.use(express.static(WEB_ROOT, { maxAge: "7d", immutable: true }));

// Always serve index.html (Flutter router)
app.get("*", (_, res) => {
  res.sendFile(path.join(WEB_ROOT, "index.html"), {
    headers: { "Cache-Control": "no-cache" }
  });
});

app.listen(PORT, () => {
  console.log(`✅ PotBot web listening on port ${PORT}`);
});
