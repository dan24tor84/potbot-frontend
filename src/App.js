import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import PrivacyPolicy from "./pages/PrivacyPolicy";
import TermsOfService from "./pages/TermsOfService";
import Security from "./pages/Security";
import Footer from "./components/Footer";
// import other pages here as needed

const App = () => {
  return (
    <Router>
      <div className="App">
        {/* Add main content here */}
        <Routes>
          <Route path="/privacy-policy" element={<PrivacyPolicy />} />
          <Route path="/terms-of-service" element={<TermsOfService />} />
          <Route path="/security" element={<Security />} />
          {/* Add your other routes here */}
        </Routes>
        <Footer />
      </div>
    </Router>
  );
};

export default App;
