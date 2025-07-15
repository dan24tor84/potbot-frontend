// capacitor.config.ts
const config = {
  appId: "com.potbot.app",
  appName: "Pot Bot",
  webDir: "../build", // Use "../build" if Android is in frontend/android
  bundledWebRuntime: false,
  android: {
    path: "frontend/android"
  }
};

export default config;
