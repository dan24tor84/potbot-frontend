import React from 'react';
import './Home.css';

const Home = () => {
  return (
    <div className="home-container">
      <h1>Welcome to Pot Bot™</h1>
      <p>Upload your bud photos and get AI-powered analysis on quality, trim, trichomes, and more.</p>
      <p>Ready to <strong>Rank Your Dank?</strong></p>
      <a href="/scan" className="cta-button">Start Scanning</a>
    </div>
  );
};

export default Home;
