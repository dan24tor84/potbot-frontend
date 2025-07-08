import React, { useState } from 'react';
import './Scan.css';

const Scan = () => {
  const [image, setImage] = useState(null);
  const [scanResult, setScanResult] = useState(null);
  const [isScanning, setIsScanning] = useState(false);
  const [error, setError] = useState(null);

  const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onloadend = () => {
      setImage(reader.result);
      setScanResult(null);
      setError(null);
    };
    reader.readAsDataURL(file);
  };

  const runAIAnalysis = async () => {
    if (!image) return;
    setIsScanning(true);
    setScanResult(null);
    setError(null);

    try {
      const response = await fetch('https://api.rankyourdank.com/analyze', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': process.env.REACT_APP_API_KEY || '' // Optional if required
        },
        body: JSON.stringify({ image: image })
      });

      if (!response.ok) {
        throw new Error(`Server error: ${response.status}`);
      }

      const data = await response.json();
      setScanResult({
        dankScore: data.dankScore,
        trichome: data.trichomeDensity,
        trim: data.trimQuality,
        impression: data.impression
      });
    } catch (err) {
      console.error('Scan failed:', err);
      setError('Scan failed. Please try again later.');
    } finally {
      setIsScanning(false);
    }
  };

  return (
    <div className="scan-container">
      <h2>Bud Bot Scanner</h2>
      <p>Upload a photo of your cannabis bud to get a real Dank Score powered by AI.</p>

      <input type="file" accept="image/*" onChange={handleImageUpload} />

      {image && <img src={image} alt="Preview" className="bud-preview" />}

      <button onClick={runAIAnalysis} disabled={isScanning || !image}>
        {isScanning ? 'Scanning...' : 'Scan Bud'}
      </button>

      {error && <div className="error-message">{error}</div>}

      {scanResult && (
        <div className="result-box">
          <h3>Scan Complete</h3>
          <p><strong>Dank Score:</strong> {scanResult.dankScore}/100</p>
          <p><strong>Trichome Density:</strong> {scanResult.trichome}</p>
          <p><strong>Trim Quality:</strong> {scanResult.trim}</p>
          <p><strong>Overall Impression:</strong> {scanResult.impression}</p>
        </div>
      )}
    </div>
  );
};

export default Scan;
