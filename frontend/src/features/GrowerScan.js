// /frontend/src/features/GrowerScan.js

import React, { useState } from 'react';
import { fetchPlantScans, updatePlantScan } from '../utils/growerAPI';

const GrowerScan = () => {
  const [image, setImage] = useState(null);
  const [preview, setPreview] = useState(null);
  const [scanResult, setScanResult] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
      setImage(file);
      const reader = new FileReader();
      reader.onloadend = () => setPreview(reader.result);
      reader.readAsDataURL(file);
    }
  };

  const handleScan = async () => {
    if (!image) return alert('Upload a plant image first');
    setLoading(true);

    try {
      const existingScans = await fetchPlantScans();
      const latest = existingScans[0];

      const result = {
        plant_name: 'Uploaded Plant',
        growth_stage: 'Flowering',
        health_score: 92,
        needs_watering: false,
        nutrient_deficiencies: 'None',
        pest_issues: 'No visible pests',
        diseases: 'No signs of disease',
        recommendations: 'Maintain current routine and prepare for harvest in ~2 weeks',
        harvest_estimate: '2 weeks',
        image_url: preview,
      };

      const updated = await updatePlantScan(latest.id, result);
      setScanResult(updated);
    } catch (err) {
      console.error(err);
      alert('Failed to complete scan');
    }

    setLoading(false);
  };

  return (
    <div className="scanner-container">
      <h2>Grower Mode - Plant Scan</h2>
      <input type="file" onChange={handleImageUpload} accept="image/*" />
      {preview && <img src={preview} alt="Preview" style={{ maxWidth: '300px', margin: '1rem 0' }} />}
      <button onClick={handleScan} disabled={loading}>
        {loading ? 'Scanning...' : 'Analyze Plant'}
      </button>
      {scanResult && (
        <div className="scan-result">
          <h3>Scan Results</h3>
          <p><strong>Stage:</strong> {scanResult.growth_stage}</p>
          <p><strong>Health Score:</strong> {scanResult.health_score}</p>
          <p><strong>Watering Needed:</strong> {scanResult.needs_watering ? 'Yes' : 'No'}</p>
          <p><strong>Nutrient Issues:</strong> {scanResult.nutrient_deficiencies}</p>
          <p><strong>Pests:</strong> {scanResult.pest_issues}</p>
          <p><strong>Diseases:</strong> {scanResult.diseases}</p>
          <p><strong>Harvest Estimate:</strong> {scanResult.harvest_estimate}</p>
          <p><strong>Recommendations:</strong> {scanResult.recommendations}</p>
        </div>
      )}
    </div>
  );
};

export default GrowerScan;
