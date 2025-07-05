// server.js – serves Pot Bot static site from the public folder via Express

const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Serve static files from the /public directory
app.use(express.static(path.join(__dirname, 'public')));

// Fallback route for single-page apps and PWA support
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(port, () => {
  console.log(`🚀 Pot Bot is live at http://localhost:${port}`);
});
