import { useState } from 'react';
import { Camera } from '@capacitor/camera';

export const useCamera = () => {
  const [photoUri, setPhotoUri] = useState(null);
  const [error, setError] = useState(null);

  const takePicture = async () => {
    try {
      const image = await Camera.getPhoto({
        quality: 90,
        allowEditing: false,
        resultType: 'uri',
        source: 'CAMERA'
      });

      setPhotoUri(image.webPath);
    } catch (err) {
      setError(err);
    }
  };

  return { takePicture, photoUri, error };
};
