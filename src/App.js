import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import NavBar from "./components/NavBar";
import Footer from "./components/Footer";
import CookieNotice from "./components/CookieNotice";
import ScanBud from "./components/ScanBud";

// Placeholder components for legal pages
const PrivacyPolicy = () => <div style={{ padding: "20px" }}><h2>Privacy Policy</h2><p>This is the privacy policy page.</p></div>;
const TermsOfService = () => <div style={{ padding: "20px" }}><h2>Terms of Service</h2><p>This is the terms of service page.</p></div>;
const Security = () => <div style={{ padding: "20px" }}><h2>Security</h2><p>This is the security practices page.</p></div>;

const App = () => {
  return (
    <Router>
      <div style={{ display: "flex", flexDirection: "column", minHeight: "100vh" }}>
        <NavBar />
        <main style={{ flex: 1 }}>
          <Routes>
            <Route path="/" element={<ScanBud />} />
            <Route path="/privacy-policy" element={<PrivacyPolicy />} />
            <Route path="/terms-of-service" element={<TermsOfService />} />
            <Route path="/security" element={<Security />} />
          </Routes>
        </main>
        <CookieNotice />
        <Footer />
      </div>
    </Router>
  );
};

export default App;
