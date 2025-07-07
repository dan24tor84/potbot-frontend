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
