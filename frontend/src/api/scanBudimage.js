// File: /frontend/src/api/scanBudImage.js

export async function scanBudImage(file) {
  const formData = new FormData();
  formData.append('image', file);

  try {
    const response = await fetch(`${process.env.REACT_APP_BACKEND_URL}/api/scan`, {
      method: 'POST',
      body: formData,
    });

    if (!response.ok) {
      throw new Error('Failed to scan bud image');
    }

    const result = await response.json();
    return result;
  } catch (error) {
    console.error('Scan error:', error);
    throw error;
  }
}
