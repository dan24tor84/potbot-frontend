// /frontend/src/utils/growerAPI.js

const GROWER_API_URL = 'https://app.base44.com/api/apps/686497ecac8949ae382bd5d3/entities/PlantScan';
const API_KEY = 'c4c720c6c60e4ba394661827f5b847d5';

export async function fetchPlantScans() {
  const response = await fetch(GROWER_API_URL, {
    headers: {
      'api_key': API_KEY,
      'Content-Type': 'application/json'
    }
  });
  return await response.json();
}

export async function updatePlantScan(entityId, updateData) {
  const response = await fetch(`${GROWER_API_URL}/${entityId}`, {
    method: 'PUT',
    headers: {
      'api_key': API_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(updateData)
  });
  return await response.json();
}
