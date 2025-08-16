# 🌿 PotBot: World's First AI-Powered Cannabis Scanner

PotBot is the **world’s first AI-powered cannabis scanner app**. 
It helps users and growers analyze cannabis buds and plants using real AI models — not mock data. 

The app scans images to provide:
- **Dank Score**: AI rating of bud quality (trichome density, trim, appearance, mold check). 
- **Grower Mode**: Detect growth stage, watering needs, nutrient balance, and harvest readiness. 
- **Leaderboard**: Rank your dank against the community. 
- **Personal Recommendations**: Get feedback and tips based on your scans. 

Deployed at: [www.rankyourdank.com](https://www.rankyourdank.com)

---

## 🚀 Features
- Real-time AI image analysis via [Railway](https://railway.app) backend + Replicate API. 
- Flutter frontend (Android, iOS, Web) for smooth cross-platform experience. 
- Scan history & unlimited uploads with **PotBot Pro**. 
- Vendor and affiliate integrations coming soon. 

---

## 📱 Platforms
- **Android** (Google Play release pending) 
- **iOS** (App Store release planned) 
- **Web** at [rankyourdank.com](https://rankyourdank.com)

---

## 🛠 Tech Stack
- **Frontend**: Flutter (Dart 3.7, Material 3, responsive UI) 
- **Backend**: Node.js + Express, hosted on Railway 
- **AI**: Replicate models + OpenAI integration 
- **Database**: MongoDB Atlas 
- **Hosting**: Railway (Frontend + Backend) 
- **CI/CD**: GitHub Actions → Railway deploy 

---

## 🔧 Development
### Requirements
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (≥ 3.27.0) 
- Dart ≥ 3.7 
- Railway CLI (`npm i -g @railway/cli`) 

### Setup
```bash
# Clone repo
git clone https://github.com/dan24tor84/potbot-frontend.git
cd potbot-frontend

# Install dependencies
flutter pub get

# Run locally
flutter run -d chrome   # or android, ios
