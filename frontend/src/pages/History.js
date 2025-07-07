import React, { useEffect, useState } from 'react';
import './History.css';

const History = () => {
  const [scans, setScans] = useState([]);

  useEffect(() => {
    // Fetch scan history from backend (placeholder)
    const dummyData = [
      {
        id: 1,
        imageUrl: '/sample1.jpg',
        dankScore: 87,
        date: '2025-07-01',
      },
      {
        id: 2,
        imageUrl: '/sample2.jpg',
        dankScore: 92,
        date: '2025-07-03',
      },
    ];
    setScans(dummyData);
  }, []);

  return (
    <div className="history-container">
      <h2>Scan History</h2>
      {scans.length === 0 ? (
        <p>No scans found.</p>
      ) : (
        <ul className="scan-list">
          {scans.map((scan) => (
            <li key={scan.id} className="scan-item">
              <img src={scan.imageUrl} alt="Bud" className="scan-image" />
              <div className="scan-details">
                <p><strong>Dank Score:</strong> {scan.dankScore}/100</p>
                <p><strong>Date:</strong> {scan.date}</p>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default History;
