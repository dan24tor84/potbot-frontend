// File: /frontend/src/App.js import React from 'react'; import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'; import Home from './pages/Home'; import Scan from './pages/Scan'; import History from './pages/History'; import NotFound from './pages/NotFound'; import Navbar from './components/Navbar';

const App = () => { return ( <Router> <Navbar /> <Routes> <Route path="/" element={<Home />} /> <Route path="/scan" element={<Scan />} /> <Route path="/history" element={<History />} /> <Route path="*" element={<NotFound />} /> </Routes> </Router> ); };

export default App;
