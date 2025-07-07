// /frontend/src/App.js

import React, { useState } from 'react';
import BudScanner from './features/BudScanner';
import GrowerScan from './features/GrowerScan';

function App() {
  const [mode, setMode] = useState('bud'); // 'bud' or 'grower'

  return (
    <div className="app-container">
      <header>
        <h1>Pot Bot – Rank Your Dank</h1>
        <nav>
          <button onClick={() => setMode('bud')} className={mode === 'bud' ? 'active' : ''}>
            Bud Bot
          </button>
          <button onClick={() => setMode('grower')} className={mode === 'grower' ? 'active' : ''}>
            Grower Mode
          </button>
        </nav>
      </header>

      <main>
        {mode === 'bud' ? <BudScanner /> : <GrowerScan />}
      </main>
    </div>
  );
}

export default App;
