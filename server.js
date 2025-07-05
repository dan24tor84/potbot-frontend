// server.js – Pot Bot live server config for Railway

const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Serve static files from /public
app.use(express.static(path.join(__dirname, 'public')));

// Fallback: serve index.html for all unmatched routes (SPA/PWA)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(port, () => {
  console.log(`🚀 Pot Bot is live at http://localhost:${port}`);
});
