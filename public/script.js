// script.js – Pot Bot basic image analyzer (mock logic)

document.addEventListener('DOMContentLoaded', () => {
  const uploadInput = document.getElementById('upload');
  const preview = document.getElementById('previewImage');
  const result = document.getElementById('result');
  const scanButton = document.getElementById('scanButton');

  uploadInput.addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (event) => {
      preview.src = event.target.result;
      preview.style.display = 'block';
    };
    reader.readAsDataURL(file);
  });

  scanButton.addEventListener('click', () => {
    if (!uploadInput.files[0]) {
      alert("Please upload an image first.");
      return;
    }

    // Mock scan result
    result.innerHTML = `
      <h2>Bud Scan Results:</h2>
      <p><strong>Dank Score:</strong> 87/100 🌿🔥</p>
      <p><strong>Trichome Density:</strong> High</p>
      <p><strong>Trim Quality:</strong> Excellent</p>
      <p><strong>Mold Check:</strong> Clean</p>
      <p><strong>Visual Health:</strong> Healthy and vibrant</p>
    `;
  });
});
