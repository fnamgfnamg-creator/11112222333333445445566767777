# FER3OON - Complete Trading Platform Ecosystem

## 📱 Project Overview

FER3OON is a complete ecosystem consisting of:
- **Flutter Mobile App** (Android)
- **Backend API** (Node.js + Express + MongoDB)
- **Admin Dashboard** (React + Vite)

All components are API-driven, cleanly separated, and fully integrated.

---

## 🏗️ Architecture

```
┌─────────────────┐
│  Flutter App    │ ──────┐
│  (Android)      │       │
└─────────────────┘       │
                          ▼
                   ┌──────────────┐
                   │  Backend API │
                   │  (Railway)   │
                   │   MongoDB    │
                   └──────────────┘
                          ▲
┌─────────────────┐       │
│ Admin Dashboard │ ──────┘
│ (React + Vite)  │
└─────────────────┘
```

---

## 🚀 Quick Start

### 1️⃣ Backend Deployment (Railway)

```bash
cd FER3OON_Backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Edit .env with your MongoDB Atlas connection string
nano .env

# Deploy to Railway
railway up

# Note your Railway backend URL
```

**Environment Variables:**
```env
PORT=3000
NODE_ENV=production
MONGODB_URI=your_mongodb_atlas_connection_string
JWT_SECRET=your_secret_key
ADMIN_USERNAME=FADY
ADMIN_PASSWORD=AMIRA
CORS_ORIGIN=https://your-frontend-url.railway.app
```

### 2️⃣ Frontend Deployment (Railway)

```bash
cd FER3OON_Frontend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Add backend URL
echo "VITE_API_URL=https://your-backend-url.railway.app" > .env

# Build
npm run build

# Deploy to Railway
railway up
```

### 3️⃣ Flutter App Setup

```bash
cd FER3OON_Flutter

# Update backend URL in constants
nano lib/core/constants.dart
# Change baseUrl to your Railway backend URL

# Get dependencies
flutter pub get

# Build APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📋 Features

### Mobile App Features
✅ Splash screen with animated logo
✅ Welcome screen with registration link
✅ UID input for account verification
✅ Pending approval screen
✅ Blocked user handling
✅ WebView trading interface (Quotex)
✅ Server-controlled signal generation
✅ Hour-based signal bias system
✅ Push notifications (approval/block)
✅ Support button (Telegram)
✅ Auto device tracking
✅ Session persistence

### Backend Features
✅ User registration & authentication
✅ Admin login with JWT
✅ Device ID tracking
✅ Auto-block on multiple device login
✅ Hour-based signal generation
✅ Signal history tracking
✅ User status management (PENDING/APPROVED/BLOCKED)
✅ Statistics API
✅ Health check endpoint
✅ Rate limiting
✅ CORS protection

### Dashboard Features
✅ Secure admin login
✅ Statistics overview
✅ User management
✅ Status filtering (All/Pending/Approved/Blocked)
✅ Approve/Block/Pending actions
✅ User deletion
✅ Real-time updates
✅ Responsive design

---

## 🔑 API Endpoints

### Public Endpoints
```
POST   /api/auth/register          - User registration
POST   /api/auth/status             - Check user status
POST   /api/signal/generate         - Generate trading signal
GET    /ping                        - Health check
```

### Admin Endpoints (Auth Required)
```
POST   /api/auth/admin/login        - Admin login
GET    /api/stats                   - Get statistics
GET    /api/users                   - Get all users
GET    /api/users/:uid              - Get user by UID
PATCH  /api/users/:uid/status       - Update user status
DELETE /api/users/:uid              - Delete user
```

---

## 🎯 Signal System Logic

### Hour-Based Bias
- Even hours (0, 2, 4, ...): 60% CALL / 40% PUT
- Odd hours (1, 3, 5, ...): 60% PUT / 40% CALL

### Rules
1. Signal only generated at start of new minute (0-5 seconds)
2. Signal duration = 60 seconds
3. User must press "GET SIGNAL" button
4. Signal appears when new candle/minute starts
5. Not random - hour-based distribution

---

## 🔒 Auto-Block Logic

**Triggered When:**
- Same UID logs in from different Device ID

**Action:**
- Block the UID
- Block both devices
- Can only be unblocked manually from dashboard

---

## 📱 Flutter Project Structure

```
lib/
├── main.dart
├── pubspec.yaml
├── services/
│   ├── auth_service.dart
│   ├── api_service.dart
│   ├── storage_service.dart
├── screens/
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── uid_input_screen.dart
│   ├── pending_screen.dart
│   ├── trading_screen.dart
├── widgets/
│   ├── signal_button.dart
│   ├── support_button.dart
│   ├── animated_background.dart
├── core/
│   ├── animation.dart
│   ├── constants.dart
│   ├── theme.dart
```

---

## 🖥️ Backend Project Structure

```
backend/
├── server.js
├── package.json
├── .env
├── routes/
│   ├── auth.js
│   ├── users.js
│   ├── stats.js
│   ├── signal.js
├── controllers/
│   ├── authController.js
│   ├── usersController.js
│   ├── statsController.js
├── middleware/
│   ├── auth.js
├── models/
│   ├── user.js
├── config/
│   ├── db.js
```

---

## 🎨 Frontend Project Structure

```
frontend/
├── index.html
├── vite.config.js
├── package.json
├── .env
├── src/
│   ├── main.jsx
│   ├── app.jsx
│   ├── pages/
│   │   ├── login.jsx
│   │   ├── dashboard.jsx
│   │   ├── users.jsx
│   ├── components/
│   │   ├── layout.jsx
│   │   ├── protectedRoutes.jsx
│   ├── services/
│   │   ├── axios.js
│   │   ├── apiService.js
│   │   ├── authService.js
│   ├── styles/
│   │   ├── index.css
│   │   ├── login.css
│   │   ├── dashboard.css
│   │   ├── users.css
│   │   ├── layout.css
```

---

## 🎨 Design Theme

### Colors
- **Primary**: Black (#000000)
- **Dark Gray**: #1A1A1A
- **Medium Gray**: #2D2D2D
- **Light Gray**: #404040
- **Gold**: #FFD700
- **Dark Gold**: #B8860B
- **White**: #FFFFFF
- **Red**: #FF4444
- **Green**: #00C851

### Style
- Professional, calm, premium look
- Smooth page transitions
- Light animated backgrounds
- Custom animations

---

## 🔐 Security Features

- JWT authentication for admin
- Bcrypt password hashing (if needed)
- Rate limiting (100 req/15min)
- CORS protection
- Helmet security headers
- Environment variables for secrets
- Input validation

---

## 📊 MongoDB Schema

### User Model
```javascript
{
  uid: String,           // Quotex Account ID
  deviceId: String,      // Unique device identifier
  status: String,        // PENDING | APPROVED | BLOCKED
  signalHistory: [{
    signal: String,      // CALL | PUT
    timestamp: Date
  }],
  createdAt: Date,
  lastLogin: Date,
  deviceHistory: [{
    deviceId: String,
    loginAt: Date
  }]
}
```

---

## 🚨 Important Notes

1. **Backend must be deployed first** before configuring Flutter app
2. Update `baseUrl` in Flutter `constants.dart` with Railway URL
3. Update `VITE_API_URL` in Frontend `.env` with Railway URL
4. Use uptime monitoring service (like UptimeRobot) to keep backend alive
5. MongoDB Atlas free tier is sufficient for testing
6. Admin credentials are hardcoded: FADY / AMIRA

---

## 🛠️ Building APK

```bash
# Navigate to Flutter project
cd FER3OON_Flutter

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# Output location
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 Dependencies

### Flutter
- webview_flutter
- http
- shared_preferences
- device_info_plus
- url_launcher
- animate_do
- firebase_core
- firebase_messaging

### Backend
- express
- mongoose
- cors
- dotenv
- helmet
- morgan
- jsonwebtoken
- bcryptjs

### Frontend
- react
- react-router-dom
- axios

---

## 🌐 External Links

- **Quotex Registration**: https://broker-qx.pro/?lid=1635606
- **Quotex Platform**: https://qxbroker.com/en/
- **Support Telegram**: http://t.me/el_fer3oon

---

## 📞 Support

For issues or questions, contact via Telegram: @el_fer3oon

---

## ✅ Deployment Checklist

- [ ] MongoDB Atlas database created
- [ ] Backend deployed to Railway
- [ ] Backend URL updated in Flutter constants
- [ ] Backend URL updated in Frontend .env
- [ ] Frontend deployed to Railway
- [ ] Uptime monitor configured for backend
- [ ] Flutter APK built successfully
- [ ] Admin can login to dashboard
- [ ] Users can register via mobile app
- [ ] Signals are generating correctly
- [ ] Auto-block is working

---

## 📝 License

Proprietary - All rights reserved

---

## 👨‍💻 Version

Version 1.0.0 - January 2026
