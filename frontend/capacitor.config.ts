import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.rankyourdank.potbot',
  appName: 'PotBot',
  webDir: 'build',
  bundledWebRuntime: false,
  plugins: {
    Keyboard: {
      resize: 'body'
    }
  },
  android: {
    path: 'android'
  },
  server: {
    cleartext: true
  }
};

export default config;
