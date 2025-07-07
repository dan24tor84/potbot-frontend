// File: /backend/routes/scan.js

const express = require('express');
const router = express.Router();
const multer = require('multer');
const { analyzeImage } = require('../utils/aiAnalyzer');

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

router.post('/', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No image uploaded' });
    }

    const result = await analyzeImage(req.file.buffer);
    res.json(result);
  } catch (error) {
    console.error('Scan error:', error);
    res.status(500).json({ error: 'Image processing failed' });
  }
});

module.exports = router;
