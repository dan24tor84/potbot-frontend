// File: /frontend/src/api/scanBudImage.js

export const scanBudImage = async (file) => {
  const formData = new FormData();
  formData.append('image', file);

  const response = await fetch(`${process.env.REACT_APP_BACKEND_URL}/api/scan`, {
    method: 'POST',
    body: formData,
  });

  if (!response.ok) {
    throw new Error('Image scan failed');
  }

  const data = await response.json();
  return data;
};
