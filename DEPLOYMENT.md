# Deployment Guide - Dalilak App

**Version:** 1.0.0  
**Last Updated:** February 23, 2026  
**Status:** Production Ready

---

## Table of Contents

1. [Environment Setup](#environment-setup)
2. [Android Deployment](#android-deployment)
3. [iOS Deployment](#ios-deployment)
4. [Backend API Setup](#backend-api-setup)
5. [Firebase Configuration](#firebase-configuration)
6. [Monitoring & Logging](#monitoring--logging)
7. [Troubleshooting](#troubleshooting)

---

## Environment Setup

### Prerequisites

```bash
# Minimum requirements
- Flutter 3.4.4+
- Dart 3.4.4+
- Java 11+ (for Android)
- Xcode 13+ (for iOS)
- CocoaPods 1.11+
```

### Development Environment

```bash
# Clone repository
git clone https://github.com/karam/dalilak_app.git
cd dalilak_app

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test --coverage

# Run app
flutter run
```

### Production Build Preparation

```bash
# Update version in pubspec.yaml
# Update build number: version: x.y.z+buildnumber

# Verify all tests pass
flutter test

# Verify code analysis passes
flutter analyze lib/

# Build for release
flutter build apk --release     # Android
flutter build ios --release     # iOS
```

---

## Android Deployment

### 1. Keystore Setup

```bash
# Create keystore (one-time)
keytool -genkey -v \
  -keystore ~/upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10950 \
  -alias upload

# Store password securely in environment variables
export KEYSTORE_PASSWORD="your_password"
export KEY_PASSWORD="your_password"
export KEY_ALIAS="upload"
```

### 2. Configure Key Properties

**File:** `android/key.properties`

```properties
storeFile=../upload-keystore.jks
storePassword=${KEYSTORE_PASSWORD}
keyAlias=${KEY_ALIAS}
keyPassword=${KEY_PASSWORD}
```

### 3. Build Release APK

```bash
# Build optimized release APK
flutter build apk --release

# Output: build/app/outputs/apk/release/app-release.apk
```

### 4. Build App Bundle (Google Play)

```bash
# Build App Bundle for Play Store
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### 5. Upload to Google Play

**Steps:**
1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app or select existing
3. Fill in app details (title, description, screenshots, etc.)
4. Upload AAB file to internal testing track first
5. Test thoroughly before promoting to production

**Metadata Required:**
- App name: "دليلك - Dalilak"
- Short description: "Find services and businesses in Egypt"
- Full description: See `STORE_DESCRIPTION.md`
- Screenshots (4.7" and 5.5" phone variants)
- Feature graphics (1024x500)
- Promo graphics (180x120)

### 6. Android Release Checklist

- [ ] Version number incremented
- [ ] Build number incremented
- [ ] All tests passing
- [ ] Code analysis passing
- [ ] Keystore secure and backed up
- [ ] App signed with production key
- [ ] AAB file generates without errors
- [ ] Store listings completed
- [ ] App rated and classified
- [ ] Content rating submitted

---

## iOS Deployment

### 1. Certificate Setup

```bash
# Generate signing certificate
open -a /Applications/Utilities/Keychain\ Access.app

# Create Certificate Signing Request (CSR)
# Request new certificate from Apple Developer

# Download and install certificate
# Install provisioning profile
```

### 2. Configure Xcode Project

**File:** `ios/Runner.xcodeproj/project.pbxproj`

```
Team ID: Your Team ID
Bundle Identifier: com.dalilak.app
Bundle Version: 1.0
Build Version: 1
```

### 3. Build Release IPA

```bash
# Build for iOS App Store
flutter build ios --release

# Archive for distribution
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  -archivePath build/Runner.xcarchive \
  archive

# Export for App Store
xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportPath build/ipa \
  -exportOptionsPlist ExportOptions.plist
```

### 4. Upload to App Store

**Steps:**
1. Open [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app or select existing
3. Fill in app information
4. Upload build using Transporter or Xcode
5. Submit for review

**Metadata Required:**
- App name
- Subtitle
- Full description
- Keywords
- Support URL
- Privacy policy URL
- Screenshots (multiple device sizes required)
- App preview (optional video)

### 5. iOS Release Checklist

- [ ] Bundle ID correct
- [ ] Team ID configured
- [ ] Certificate and provisioning profile installed
- [ ] All tests passing
- [ ] Build version incremented
- [ ] Code signing verified
- [ ] IPA generated successfully
- [ ] App Store Connect metadata complete
- [ ] Privacy policy updated
- [ ] Screenshots prepared for all device sizes

---

## Backend API Setup

### 1. Environment Configuration

**File:** `.env.production`

```env
API_BASE_URL=https://api.dalilak.com
API_TIMEOUT=30000
CACHE_TTL=3600000
LOG_LEVEL=warning
```

**File:** `lib/config/env.ts` (Backend)

```dart
const String apiBaseUrl = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'https://api.dalilak.com');
const int cacheTimeMs = int.fromEnvironment('CACHE_TTL',
    defaultValue: 3600000); // 1 hour
```

### 2. API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/categories` | GET | Fetch all categories |
| `/governorates` | GET | Fetch all governorates |
| `/listings` | GET | Fetch listings with pagination |
| `/listings/{id}` | GET | Fetch single listing |
| `/search` | GET | Search listings |
| `/notifications` | GET | Fetch notifications |
| `/ads` | GET | Fetch advertisements |
| `/listings/{id}/reviews` | GET | Fetch reviews |
| `/listings/{id}/reviews` | POST | Submit review |

### 3. Rate Limiting

```
- 100 requests per minute (default user)
- 1,000 requests per minute (premium)
- Pagination limit: 100 items max per request
```

### 4. Caching Headers

```
Categories:       Cache-Control: max-age=3600
Governorates:     Cache-Control: max-age=86400
Listings:         Cache-Control: max-age=600
Search results:   Cache-Control: max-age=300
Ads:              Cache-Control: max-age=1800
Notifications:    Cache-Control: max-age=60
```

### 5. Error Handling

**Standard Error Response:**

```json
{
  "success": false,
  "message": "Error description",
  "code": "ERROR_CODE",
  "data": null,
  "timestamp": "2024-02-23T10:30:00Z"
}
```

**Common Error Codes:**

| Code | HTTP | Meaning |
|------|------|---------|
| `INVALID_REQUEST` | 400 | Bad request parameters |
| `UNAUTHORIZED` | 401 | Authentication required |
| `FORBIDDEN` | 403 | Access denied |
| `NOT_FOUND` | 404 | Resource not found |
| `RATE_LIMIT` | 429 | Too many requests |
| `SERVER_ERROR` | 500 | Internal server error |

---

## Firebase Configuration

### 1. Setup Firebase Project

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project
firebase init
```

### 2. Android Integration

**File:** `android/app/google-services.json`

```bash
# Download from Firebase Console
# Place in android/app/ directory
```

### 3. iOS Integration

**File:** `ios/Runner/GoogleService-Info.plist`

```bash
# Download from Firebase Console
# Place in ios/Runner/ directory
```

### 4. Enable Services

- [x] Real-time Database
- [x] Cloud Firestore
- [x] Storage
- [x] Authentication
- [x] Analytics
- [x] Crashes
- [x] Performance

### 5. Security Rules

**Firestore Rules:**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /listings/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /reviews/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

---

## Monitoring & Logging

### 1. Firebase Crashlytics

```dart
// Configure in main()
await Firebase.initializeApp();
FirebaseCrashlytics.instance
    .setCrashlyticsCollectionEnabled(!kDebugMode);

// Log custom errors
FirebaseCrashlytics.instance.recordError(error, stackTrace);
```

### 2. Firebase Analytics

```dart
// Track custom events
FirebaseAnalytics.instance.logEvent(
  name: 'listing_viewed',
  parameters: {
    'listing_id': listingId,
    'category_id': categoryId,
  },
);
```

### 3. Performance Monitoring

```dart
// Track API response times
final trace = FirebasePerformance.instance
    .newHttpMetric(url, HttpMethod.Get);
await trace.start();
// Make request
final response = await http.get(url);
await trace.stop();
```

### 4. Logs & Errors

**Production Logs Location:**
- Analytics: Firebase Console
- Crashes: Firebase Crashlytics
- Performance: Firebase Performance Dashboard

---

## Troubleshooting

### Build Issues

**Problem:** Build fails with "gradle sync error"
```bash
# Solution
cd android/
./gradlew clean
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build
```

**Problem:** "Keystore file not found"
```bash
# Solution
export KEYSTORE_PATH=$HOME/upload-keystore.jks
export STOREPASS="your_password"
export KEYPASS="your_password"
```

### Release Issues

**Problem:** "Invalid signature" on Google Play
```bash
# Solution: Verify keystore
keytool -list -v -keystore ~/upload-keystore.jks
```

**Problem:** "App age rating required"
```bash
# Solution: Fill age rating questionnaire in Google Play Console
```

### Runtime Issues

**Problem:** API requests timing out
```dart
// Increase timeout in ApiClient
final duration = Duration(seconds: 60);
dio.options.connectTimeout = duration;
dio.options.receiveTimeout = duration;
```

**Problem:** Cache not clearing
```dart
// Clear cache manually
await cacheService.clearAllCache();
```

### Performance Issues

**Problem:** App crashes on low-memory devices
```dart
// Use image caching limits
imageCache.maximumSize = 100;
imageCache.maximumSizeBytes = 100 * 1024 * 1024; // 100MB
```

---

## Rollback Procedures

### Android

```bash
# If release has critical bugs
# 1. Upload new APK/AAB with higher version number
# 2. Mark previous release as deprecated
# 3. Announce issue on all channels
```

### iOS

```bash
# If release has critical bugs
# 1. Build with higher version number
# 2. Resubmit to App Store
# 3. Immediately pull previous version
```

---

## Monitoring Dashboard

### Recommended Tools

- **Firebase Console** - Crashes, analytics, performance
- **Google Play Console** - App ratings, reviews, stats
- **App Store Connect** - iOS analytics and statistics
- **DataDog/New Relic** - APM monitoring (optional)

### Key Metrics to Monitor

- Daily active users (DAU)
- Crash rate (target: < 0.1%)
- API response time (target: < 500ms)
- Cache hit rate (target: > 70%)
- User retention (7-day, 30-day)

---

## Deployment Checklist

- [ ] All tests passing (100%)
- [ ] Code analysis clean
- [ ] Version number updated
- [ ] Build number incremented
- [ ] Release notes prepared
- [ ] Screenshots updated
- [ ] Metadata complete
- [ ] Environment variables set
- [ ] Keystore backed up
- [ ] API endpoints verified
- [ ] Cache strategy validated
- [ ] Offline mode tested
- [ ] Performance benchmarked
- [ ] Security audit passed
- [ ] Monitoring configured
- [ ] Rollback plan ready

---

## Contact & Support

- **Technical Issues:** tech@dalilak.com
- **Deployment Help:** devops@dalilak.com
- **Documentation:** docs.dalilak.com

**Emergency Hotline:** +20 1234567890

---

**Last Updated:** February 23, 2026  
**Next Review:** March 23, 2026
