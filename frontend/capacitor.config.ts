import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.potbot.app',
  appName: 'PotBot',
  webDir: 'build',
  bundledWebRuntime: false,
  android: {
    path: 'android',
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 0,
    },
  },
};

export default config;
