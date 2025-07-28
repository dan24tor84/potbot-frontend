import React from "react";

const Security = () => {
  return (
    <div style={{ padding: "20px" }}>
      <h2>Security Practices</h2>
      <p>
        PotBot uses secure HTTPS and follows best practices to protect your uploads and interactions.
        Your image data is processed in real-time and not saved unless explicitly permitted.
      </p>
      <p>
        We implement secure API keys and monitor third-party services (OpenAI, Replicate, Firebase)
        for any vulnerabilities.
      </p>
    </div>
  );
};

export default Security;
