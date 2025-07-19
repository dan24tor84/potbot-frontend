// frontend/capacitor.config.ts

import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.rankyourdank.potbot',
  appName: 'PotBot',
  webDir: 'build',
  bundledWebRuntime: false,
  android: {
    allowMixedContent: true
  }
};

export default config;
