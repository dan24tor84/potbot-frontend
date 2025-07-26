// backend/utils/aiAnalyzer.js

const { Configuration, OpenAIApi } = require("openai");

const configuration = new Configuration({
  apiKey: process.env.OpenAI,
});

const openai = new OpenAIApi(configuration);

/**
 * Analyze a cannabis image and return AI-based insights.
 * @param {string} base64Image - A base64-encoded image string (data:image/jpeg;base64,...)
 * @returns {Promise<Object>} - AI analysis result
 */
async function analyzeImage(base64Image) {
  try {
    const response = await openai.createChatCompletion({
      model: "gpt-4-vision-preview",
      messages: [
        {
          role: "system",
          content: "You're an expert cannabis quality inspector. Analyze trichomes, trim, mold, and visual quality from the photo provided. Provide a Dank Score (0–100) and 3 expert tips.",
        },
        {
          role: "user",
          content: [
            {
              type: "text",
              text: "Please analyze this cannabis bud image and rate its quality.",
            },
            {
              type: "image_url",
              image_url: {
                url: base64Image,
              },
            },
          ],
        },
      ],
      max_tokens: 1000,
    });

    const result = response.data.choices[0].message.content;

    return {
      success: true,
      analysis: result,
    };
  } catch (err) {
    console.error("OpenAI error:", err?.response?.data || err.message);
    return {
      success: false,
      error: "Failed to analyze image with AI.",
    };
  }
}

module.exports = { analyzeImage };
