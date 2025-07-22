import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.rankyourdank.potbot',
  appName: 'PotBot',
  webDir: 'build',
  bundledWebRuntime: false,
  plugins: {
    SplashScreen: {
      launchShowDuration: 0,
    },
  },
  android: {
    path: 'android'
  }
};

export default config;
