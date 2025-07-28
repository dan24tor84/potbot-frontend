import React, { useEffect, useState } from "react";

const CookieNotice = () => {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const accepted = localStorage.getItem("cookieConsent");
    if (!accepted) {
      setVisible(true);
    }
  }, []);

  const acceptCookies = () => {
    localStorage.setItem("cookieConsent", "true");
    setVisible(false);
  };

  if (!visible) return null;

  return (
    <div style={styles.banner}>
      <p style={styles.text}>
        This app uses cookies to enhance the user experience. By using PotBot, you agree to our use of cookies.
      </p>
      <button style={styles.button} onClick={acceptCookies}>
        Accept
      </button>
    </div>
  );
};

const styles = {
  banner: {
    position: "fixed",
    bottom: 0,
    width: "100%",
    backgroundColor: "#222",
    color: "#fff",
    padding: "10px 20px",
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    zIndex: 9999,
  },
  text: {
    margin: 0,
    fontSize: "14px",
  },
  button: {
    marginLeft: "10px",
    padding: "6px 12px",
    backgroundColor: "#00c853",
    color: "#fff",
    border: "none",
    borderRadius: "4px",
    cursor: "pointer",
  },
};

export default CookieNotice;
