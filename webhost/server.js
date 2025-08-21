const express = require("express");
const path = require("path");
const app = express();

const PORT = process.env.PORT || 8080;
const WEB_ROOT = path.join(__dirname, "build", "web");

// Serve static files from Flutter web build
app.use(express.static(WEB_ROOT, { maxAge: "7d", immutable: true }));

// Route everything else to index.html (for Flutter router)
app.get("*", (_, res) => {
  res.sendFile(path.join(WEB_ROOT, "index.html"));
});

app.listen(PORT, () => {
  console.log(`✅ PotBot web listening on port ${PORT}`);
});