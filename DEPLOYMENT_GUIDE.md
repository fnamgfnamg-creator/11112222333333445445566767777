# 🚀 FER3OON Deployment Guide

## Prerequisites

- MongoDB Atlas account (free tier)
- Railway account (free tier)
- Flutter SDK installed
- Node.js installed (v18+)
- Git installed

---

## Step 1: Setup MongoDB Atlas

1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a free cluster
3. Create a database user
4. Whitelist IP: `0.0.0.0/0` (allow from anywhere)
5. Get connection string:
   ```
   mongodb+srv://username:password@cluster.mongodb.net/fer3oon?retryWrites=true&w=majority
   ```

---

## Step 2: Deploy Backend to Railway

### Using Railway Dashboard

1. Go to [Railway](https://railway.app)
2. Click "New Project"
3. Choose "Deploy from GitHub repo" or "Empty Project"
4. Upload FER3OON_Backend folder
5. Add environment variables:
   ```
   MONGODB_URI=your_mongodb_connection_string
   JWT_SECRET=your_random_secret_key
   ADMIN_USERNAME=FADY
   ADMIN_PASSWORD=AMIRA
   NODE_ENV=production
   PORT=3000
   ```
6. Generate Domain to get public URL

---

## Step 3: Deploy Frontend

1. Create new Railway project
2. Deploy FER3OON_Frontend folder
3. Add environment variable:
   ```
   VITE_API_URL=https://your-backend-url.railway.app
   ```
4. Generate domain

---

## Step 4: Build Flutter APK

```bash
cd FER3OON_Flutter

# Update backend URL in lib/core/constants.dart
flutter clean
flutter pub get
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

✅ **Complete!**
