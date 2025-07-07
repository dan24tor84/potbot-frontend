import React, { useState } from 'react';
import './Scan.css';

const Scan = () => {
  const [file, setFile] = useState(null);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState(null);

  const handleFileChange = (e) => {
    setFile(e.target.files[0]);
    setResult(null);
  };

  const handleUpload = async () => {
    if (!file) return;

    setLoading(true);
    const formData = new FormData();
    formData.append('image', file);

    try {
      const res = await fetch(`${process.env.REACT_APP_BACKEND_URL}/api/analyze`, {
        method: 'POST',
        body: formData,
      });
      const data = await res.json();
      setResult(data);
    } catch (err) {
      console.error('Upload failed:', err);
      setResult({ error: 'Upload failed. Please try again.' });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="scan-container">
      <h2>Upload a Bud Photo</h2>
      <input type="file" accept="image/*" onChange={handleFileChange} />
      <button onClick={handleUpload} disabled={!file || loading}>
        {loading ? 'Analyzing...' : 'Analyze'}
      </button>

      {result && (
        <div className="result-box">
          {result.error ? (
            <p className="error">{result.error}</p>
          ) : (
            <>
              <p><strong>Dank Score:</strong> {result.dankScore}</p>
              <p><strong>Analysis:</strong> {result.analysis}</p>
            </>
          )}
        </div>
      )}
    </div>
  );
};

export default Scan;
