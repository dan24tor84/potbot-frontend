// File: backend/routes/scan.js
const express = require('express');
const router = express.Router();

// Simulated AI bud scanner
router.post('/', async (req, res) => {
  try {
    const { image } = req.body;

    if (!image) {
      return res.status(400).json({ error: 'Image is required' });
    }

    // Fake AI scoring logic (replace with real model later)
    const fakeScore = Math.floor(Math.random() * 30) + 70;

    res.json({
      dankScore: fakeScore,
      trichomeDensity: fakeScore > 85 ? 'High' : 'Moderate',
      trimQuality: fakeScore > 80 ? 'Excellent' : 'Fair',
      impression: fakeScore > 90 ? 'Top-shelf. Sticky & frosty.' : 'Mid-tier but smokeable.'
    });
  } catch (err) {
    res.status(500).json({ error: 'Scan failed. Try again.' });
  }
});

module.exports = router;
