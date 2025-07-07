import React, { useEffect, useState } from 'react';
import './History.css';

const History = () => {
  const [history, setHistory] = useState([]);

  useEffect(() => {
    const saved = localStorage.getItem('budScanHistory');
    if (saved) {
      setHistory(JSON.parse(saved));
    }
  }, []);

  return (
    <div className="history-container">
      <h2>Scan History</h2>
      {history.length === 0 ? (
        <p>No previous scans found.</p>
      ) : (
        <ul className="scan-list">
          {history.map((entry, idx) => (
            <li key={idx} className="scan-item">
              <img src={entry.imageUrl} alt={`Scan ${idx}`} className="scan-thumb" />
              <div>
                <p><strong>Dank Score:</strong> {entry.dankScore}/100</p>
                <p><strong>Trichome:</strong> {entry.trichome}</p>
                <p><strong>Trim:</strong> {entry.trim}</p>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default History;
