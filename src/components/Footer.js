import React from "react";
import { Link } from "react-router-dom";

const Footer = () => {
  return (
    <footer style={{ background: "#111", color: "#fff", padding: "20px", textAlign: "center" }}>
      <p>&copy; {new Date().getFullYear()} PotBot. All rights reserved.</p>
      <div style={{ marginTop: "10px" }}>
        <Link to="/privacy-policy" style={{ color: "#fff", marginRight: "10px" }}>
          Privacy Policy
        </Link>
        <Link to="/terms-of-service" style={{ color: "#fff", marginRight: "10px" }}>
          Terms of Service
        </Link>
        <Link to="/security" style={{ color: "#fff" }}>
          Security
        </Link>
      </div>
    </footer>
  );
};

export default Footer;
