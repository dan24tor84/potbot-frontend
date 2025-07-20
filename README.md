# PotBot 🌿🤖

**PotBot** is the world's first cannabis visual analysis and AI ranking app — powered by machine learning and built with modern cross-platform web technologies. Users can upload images of cannabis buds or plants and receive an AI-generated "Dank Score" based on trichome density, trim quality, mold detection, and other visual traits.

---

## 🚀 Features

- 🔍 **Bud Bot**: Rate visual quality of cannabis nugs using AI
- 🌱 **Pro Grower Mode**: Analyze plant health, growth stage, and harvest readiness
- 🧠 AI model trained on visual cannabis quality indicators
- 📊 Scan History, Tips, and Pro Insights (with upgrade)
- 🌐 Hosted on [Railway](https://railway.app), website at [rankyourdank.com](https://rankyourdank.com)
- 📱 Built with Capacitor + React + Firebase + MongoDB

---

## 📁 Project Structure

```
potbot/
├── frontend/                  # React app frontend
│   ├── android/               # Android build folder (Capacitor)
│   ├── public/                # Static assets
│   └── src/                   # React components, pages, logic
├── backend/ (optional)        # Express or serverless backend (Railway)
└── .github/                   # GitHub Actions (APK build, etc.)
```

---

## 🛠 Tech Stack

- **Frontend**: React, TypeScript, Yarn, Capacitor
- **Backend**: Node.js, Express, MongoDB (Railway)
- **AI**: Custom vision model for cannabis analysis
- **Mobile**: Android Studio + Gradle (Groovy DSL)
- **Cloud**: Firebase (Analytics + App config)
- **CI/CD**: GitHub Actions for APK builds

---

## 🧪 Running Locally

```bash
cd frontend
yarn install
yarn build
npx cap sync
npx cap open android
```

To generate the APK:

```bash
npx cap build android --prod
```

---

## 🔐 Keystore Info

- Signing key: `potbotkey`
- Path: stored locally in `frontend/android/app/potbot-release-key.jks`
- Passwords stored in `keystore.properties` (ignored via `.gitignore`)

---

## 📸 Screenshots

Coming soon…

---

## 📄 License

© 2025 Silent Systems. All rights reserved.
