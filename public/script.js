// script.js – Pot Bot scanner logic for ranking cannabis bud quality

document.addEventListener('DOMContentLoaded', () => {
  const fileInput = document.getElementById('upload');        // Matches: <input id="upload" />
  const scanBtn = document.getElementById('scanButton');      // Matches: <button id="scanButton">Scan</button>
  const resultDiv = document.getElementById('result');        // Matches: <div id="result"></div>
  const previewImg = document.getElementById('previewImage'); // Matches: <img id="previewImage" />

  scanBtn.addEventListener('click', () => {
    const file = fileInput.files[0];
    if (!file) {
      resultDiv.innerHTML = "<p>Please upload a cannabis bud image first.</p>";
      return;
    }

    // Show preview of uploaded image
    const reader = new FileReader();
    reader.onload = function(e) {
      previewImg.src = e.target.result;
      previewImg.style.display = 'block';
    };
    reader.readAsDataURL(file);

    // Simulate a scan result (for demo/testing purposes)
    setTimeout(() => {
      const fakeDankScore = Math.floor(Math.random() * 41) + 60; // Random score: 60–100
      resultDiv.innerHTML = `
        <h3>Scan Complete 🌿</h3>
        <p><strong>Dank Score:</strong> ${fakeDankScore}/100</p>
        <p><strong>Trichome Density:</strong> High</p>
        <p><strong>Trim Quality:</strong> Good</p>
        <p><strong>Overall Impression:</strong> This bud is looking 🔥</p>
      `;
    }, 1500);
  });
});
