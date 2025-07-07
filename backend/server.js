// File: /backend/server.js

const express = require('express');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { analyzeImage } = require('./utils/aiAnalyzer');

const app = express();
const port = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Static file serving for frontend build
app.use(express.static(path.join(__dirname, '../frontend/build')));

// Multer setup for image upload
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 }, // Max 10MB
});

// API Route: Analyze cannabis image
app.post('/api/analyze', upload.single('image'), async (req, res) => {
  try {
    const result = await analyzeImage(req.file.buffer);
    res.json({ success: true, result });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Catch-all to serve React frontend
app.get('*', (req, res) => {
  res.sendFile(path.resolve(__dirname, '../frontend/build/index.html'));
});

// Start server
app.listen(port, () => {
  console.log(`Backend running on http://localhost:${port}`);
});
