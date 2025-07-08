import React, { useState } from 'react';
import './Scan.css';

const Scan = () => {
  const [image, setImage] = useState(null);
  const [scanResult, setScanResult] = useState(null);
  const [isScanning, setIsScanning] = useState(false);

  const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onloadend = () => {
      setImage(reader.result);
      setScanResult(null);
    };
    reader.readAsDataURL(file);
  };

  const simulateScan = () => {
    if (!image) return;
    setIsScanning(true);

    setTimeout(() => {
      const fakeScore = Math.floor(Math.random() * 41) + 60;
      setScanResult({
        dankScore: fakeScore,
        trichome: 'High',
        trim: 'Good',
        impression: 'This bud has solid quality',
      });
      setIsScanning(false);
    }, 1500);
  };

  return (
    <div className="scan-container">
      <h2>Bud Bot Scanner</h2>
      <p>Upload a photo of your cannabis bud to get a Dank Score.</p>

      <input type="file" accept="image/*" onChange={handleImageUpload} />

      {image && <img src={image} alt="Preview" className="bud-preview" />}

      <button onClick={simulateScan} disabled={isScanning || !image}>
        {isScanning ? 'Scanning...' : 'Scan Bud'}
      </button>

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
