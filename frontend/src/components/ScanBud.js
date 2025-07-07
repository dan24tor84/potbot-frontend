// File: /frontend/src/components/ScanBud.js

import React, { useState } from 'react';
import { scanBudImage } from '../api/scanBudImage';

const ScanBud = () => {
  const [file, setFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleFileChange = (e) => {
    const uploadedFile = e.target.files[0];
    setFile(uploadedFile);
    if (uploadedFile) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setPreview(reader.result);
      };
      reader.readAsDataURL(uploadedFile);
    }
  };

  const handleScan = async () => {
    if (!file) {
      setError('Please upload a cannabis bud image.');
      return;
    }

    setLoading(true);
    setError('');
    setResult(null);

    try {
      const response = await scanBudImage(file);
      setResult(response);
    } catch (err) {
      setError('Failed to analyze image. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="scan-bud-container">
      <h2>Scan Your Bud</h2>
      <input type="file" accept="image/*" onChange={handleFileChange} />
      <button onClick={handleScan} disabled={loading}>
        {loading ? 'Scanning...' : 'Scan Bud'}
      </button>

      {preview && <img src={preview} alt="Preview" className="preview-image" />}

      {error && <p className="error-text">{error}</p>}

      {result && (
        <div className="scan-results">
          <h3>Results</h3>
          <p><strong>Dank Score:</strong> {result.dankScore}/100</p>
          <p><strong>Trichome Density:</strong> {result.trichomeDensity}</p>
          <p><strong>Trim Quality:</strong> {result.trimQuality}</p>
          <p><strong>Mold Detected:</strong> {result.moldDetected ? 'Yes' : 'No'}</p>
          <p><strong>Strain Estimate:</strong> {result.strainEstimate}</p>
          <p><strong>Harvest Readiness:</strong> {result.harvestReadiness}</p>
        </div>
      )}
    </div>
  );
};

export default ScanBud;
