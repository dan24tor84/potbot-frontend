// routes/scan.js
const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { analyzeBudImage, analyzeGrowImage } = require('../utils/aiAnalyzer');

const router = express.Router();

// Configure multer storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = path.join(__dirname, '..', 'uploads');
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath);
    }
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const name = Date.now() + ext;
    cb(null, name);
  }
});
const upload = multer({ storage });

// Route: POST /scan/bud
router.post('/bud', upload.single('image'), (req, res) => {
  if (!req.file) return res.status(400).json({ error: 'No image uploaded' });

  const result = analyzeBudImage(req.file.path);
  res.json({ success: true, result });
});

// Route: POST /scan/grow
router.post('/grow', upload.single('image'), (req, res) => {
  if (!req.file) return res.status(400).json({ error: 'No image uploaded' });

  const result = analyzeGrowImage(req.file.path);
  res.json({ success: true, result });
});

module.exports = router;
