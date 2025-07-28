import React from 'react';
import { useCamera } from './hooks/useCamera';

const CameraButton = () => {
  const { takePicture, photoUri, error } = useCamera();

  return (
    <div style={{ textAlign: 'center', padding: '2rem' }}>
      <button onClick={takePicture}>Take Photo</button>
      {photoUri && <img src={photoUri} alt="Captured" style={{ marginTop: '1rem', maxWidth: '100%' }} />}
      {error && <p style={{ color: 'red' }}>{error}</p>}
    </div>
  );
};

export default CameraButton;
