// backend/utils/aiAnalyzer.js
function analyzeImage(base64Image) {
  // This mock function simulates AI scoring based on image input
  const randomScore = Math.floor(Math.random() * 30) + 70;

  return {
    dankScore: randomScore,
    trichomeDensity: randomScore > 85 ? 'High' : 'Moderate',
    trimQuality: randomScore > 80 ? 'Excellent' : 'Fair',
    impression:
      randomScore > 90
        ? 'Top-shelf. Sticky & frosty.'
        : 'Mid-tier but smokeable.',
  };
}

module.exports = { analyzeImage };
