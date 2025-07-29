import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import './NavBar.css';

const Navbar = () => {
  const location = useLocation();

  return (
    <nav className="navbar">
      <div className="logo">🌿 Pot Bot</div>
      <ul className="nav-links">
        <li className={location.pathname === '/' ? 'active' : ''}>
          <Link to="/">Home</Link>
        </li>
        <li className={location.pathname === '/budbot' ? 'active' : ''}>
          <Link to="/budbot">Bud Bot</Link>
        </li>
        <li className={location.pathname === '/grower' ? 'active' : ''}>
          <Link to="/grower">Grower Mode</Link>
        </li>
        <li className={location.pathname === '/pro' ? 'active' : ''}>
          <Link to="/pro">Pro Mode</Link>
        </li>
      </ul>
    </nav>
  );
};

export default Navbar;
