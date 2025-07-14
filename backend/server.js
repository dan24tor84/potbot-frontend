// backend/server.js

const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Pot Bot backend is live!');
});

// Add your other API routes here

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});