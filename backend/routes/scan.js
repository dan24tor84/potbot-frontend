// backend/routes/scan.js
const express = require('express');
const router = express.Router();
const { analyzeImage } = require('../utils/aiAnalyzer');

router.post('/', async (req, res) => {
  try {
    const { image } = req.body;

    if (!image) {
      return res.status(400).json({ error: 'No image provided' });
    }

    const result = await analyzeImage(image); // ✅ FIX: added await
    res.json(result);
  } catch (error) {
    console.error('Error during scan:', error);
    res.status(500).json({ error: 'Failed to analyze image' });
  }
});

module.exports = router;
