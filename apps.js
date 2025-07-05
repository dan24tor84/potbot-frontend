const fileInput = document.getElementById('upload');
const scanBtn = document.getElementById('scanButton');
document.addEventListener('DOMContentLoaded', () => {
  const fileInput = document.getElementById('imageUpload');
  const scanBtn = document.getElementById('scanBtn');
  const resultDiv = document.getElementById('result');
  const previewImg = document.getElementById('previewImage');

  scanBtn.addEventListener('click', () => {
    const file = fileInput.files[0];
    if (!file) {
      resultDiv.innerHTML = "<p>Please upload a cannabis bud image first.</p>";
      return;
    }

    // Show preview
    const reader = new FileReader();
    reader.onload = function(e) {
      previewImg.src = e.target.result;
      previewImg.style.display = 'block';
    };
    reader.readAsDataURL(file);

    // Simulated scan result
    setTimeout(() => {
      const fakeDankScore = Math.floor(Math.random() * 41) + 60; // 60–100 range
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
