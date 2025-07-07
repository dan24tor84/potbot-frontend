import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import Home from './pages/Home';
import BudBot from './pages/BudBot';
import GrowerMode from './pages/GrowerMode';
import ProMode from './pages/ProMode';
import Navbar from './components/Navbar';

import './App.css';

const App = () => {
  return (
    <Router>
      <div className="app-container">
        <Navbar />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/budbot" element={<BudBot />} />
          <Route path="/grower" element={<GrowerMode />} />
          <Route path="/pro" element={<ProMode />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
