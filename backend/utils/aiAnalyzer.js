const axios = require('axios');

// Make sure this is set in your .env
const REPLICATE_API_TOKEN = process.env.REPLICATE_API_TOKEN;

// Replicate model for cannabis quality detection (example placeholder)
const MODEL_URL = "https://api.replicate.com/v1/predictions";

async function analyzeImage(base64Image) {
  try {
    const response = await axios.post(MODEL_URL, {
      version: "cjwbw/bud-quality-scanner", // Example Replicate model
      input: {
        image: base64Image,
      },
    }, {
      headers: {
        Authorization: `Token ${REPLICATE_API_TOKEN}`,
        'Content-Type': 'application/json',
      }
    });

    const output = response.data;

    // Extract and format the results
    return {
      dankScore: output?.output?.score || 80,
      trichomeDensity: output?.output?.trichomes || 'Moderate',
      trimQuality: output?.output?.trim || 'Clean',
      moldRisk: output?.output?.mold || 'Low',
      impression: output?.output?.description || 'Looks pretty good!'
    };
  } catch (error) {
    console.error("AI analysis error:", error.response?.data || error.message);
    return {
      dankScore: 75,
      trichomeDensity: 'Unknown',
      trimQuality: 'Unknown',
      moldRisk: 'Unknown',
      impression: 'AI analysis failed — using fallback values.'
    };
  }
}

module.exports = { analyzeImage };
