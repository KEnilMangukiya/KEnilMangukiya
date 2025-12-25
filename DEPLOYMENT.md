# Deployment Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Build Configuration](#build-configuration)
3. [Android Deployment](#android-deployment)
4. [iOS Deployment](#ios-deployment)
5. [Web Deployment](#web-deployment)
6. [Environment Setup](#environment-setup)
7. [CI/CD Setup](#cicd-setup)

---

## Prerequisites

### Required Tools
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio (for Android builds)
- Xcode (for iOS builds, macOS only)
- Git

### Verify Installation
```bash
flutter doctor -v
```

---

## Build Configuration

### 1. Update App Information

**pubspec.yaml**:
```yaml
name: call_info_app
description: Professional call management application
version: 1.0.0+1  # version+build_number
```

**Android (`android/app/build.gradle`)**:
```gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.call_info_app"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

**iOS (`ios/Runner/Info.plist`)**:
```xml
<key>CFBundleDisplayName</key>
<string>Call Info Manager</string>
<key>CFBundleIdentifier</key>
<string>com.yourcompany.callInfoApp</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
```

### 2. App Icon

Place your app icon in the following locations:

**Using flutter_launcher_icons package**:

Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  min_sdk_android: 21
```

Generate icons:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

---

## Android Deployment

### 1. Create Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Configure Signing

Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 3. Build Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### 4. Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 5. Google Play Store Submission

1. Create a Google Play Console account
2. Create a new application
3. Fill in store listing details:
   - Title: "Call Info Manager"
   - Short description
   - Full description
   - Screenshots (minimum 2)
   - Feature graphic
4. Upload the AAB file
5. Complete content rating questionnaire
6. Set pricing and distribution
7. Submit for review

---

## iOS Deployment

### 1. Configure Signing

Open `ios/Runner.xcworkspace` in Xcode:
1. Select Runner target
2. Go to "Signing & Capabilities"
3. Select your team
4. Ensure "Automatically manage signing" is checked
5. Update Bundle Identifier

### 2. Update Info.plist Permissions

Add required permissions in `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to your photo library</string>
<key>NSCameraUsageDescription</key>
<string>This app requires camera access</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app requires microphone access for calls</string>
```

### 3. Build for Release

```bash
flutter build ios --release
```

### 4. Create Archive in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Any iOS Device" as target
3. Product → Archive
4. Wait for archive to complete
5. Click "Distribute App"
6. Select "App Store Connect"
7. Follow the prompts

### 5. App Store Submission

1. Create App Store Connect account
2. Create new app
3. Fill in app information:
   - Name: "Call Info Manager"
   - Subtitle
   - Category: Business
   - Description
   - Keywords
   - Screenshots (required for all device sizes)
4. Upload build from Xcode
5. Submit for review

---

## Web Deployment

### 1. Build for Web

```bash
flutter build web --release
```

Output: `build/web/`

### 2. Configure for Production

Create `web/index.html` with proper configuration:
```html
<!DOCTYPE html>
<html>
<head>
  <base href="/">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Call Info Manager</title>
</head>
<body>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
</html>
```

### 3. Deployment Options

#### Option A: Firebase Hosting

```bash
npm install -g firebase-tools
firebase login
firebase init hosting
firebase deploy
```

`firebase.json`:
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [{
      "source": "**",
      "destination": "/index.html"
    }]
  }
}
```

#### Option B: Netlify

1. Create account at netlify.com
2. Drag and drop `build/web` folder
3. Or connect GitHub repository
4. Configure build settings:
   - Build command: `flutter build web`
   - Publish directory: `build/web`

#### Option C: Vercel

```bash
npm i -g vercel
vercel --prod
```

#### Option D: AWS S3 + CloudFront

```bash
aws s3 sync build/web s3://your-bucket-name --delete
aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"
```

---

## Environment Setup

### 1. Multiple Environments

Create environment-specific files:

**lib/config/env/dev.dart**:
```dart
class Environment {
  static const String apiUrl = 'https://dev-api.example.com';
  static const String appName = 'Call Info Manager (Dev)';
  static const bool enableLogging = true;
}
```

**lib/config/env/prod.dart**:
```dart
class Environment {
  static const String apiUrl = 'https://api.example.com';
  static const String appName = 'Call Info Manager';
  static const bool enableLogging = false;
}
```

### 2. Build with Environment

```bash
# Development
flutter run --dart-define=ENVIRONMENT=dev

# Production
flutter build apk --release --dart-define=ENVIRONMENT=prod
```

### 3. Load Environment

```dart
const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');

void main() {
  if (environment == 'prod') {
    // Load production config
  } else {
    // Load development config
  }
  runApp(MyApp());
}
```

---

## CI/CD Setup

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/app-release.apk
  
  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build iOS
        run: flutter build ios --release --no-codesign
  
  build-web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build Web
        run: flutter build web --release
      
      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: your-project-id
```

### GitLab CI

Create `.gitlab-ci.yml`:

```yaml
stages:
  - test
  - build
  - deploy

variables:
  FLUTTER_VERSION: "3.16.0"

before_script:
  - apt-get update -qq
  - apt-get install -y -qq git curl unzip
  - git clone https://github.com/flutter/flutter.git -b stable --depth 1
  - export PATH="$PATH:`pwd`/flutter/bin"
  - flutter doctor

test:
  stage: test
  script:
    - flutter pub get
    - flutter analyze
    - flutter test

build-android:
  stage: build
  script:
    - flutter build apk --release
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk

build-ios:
  stage: build
  tags:
    - macos
  script:
    - flutter build ios --release --no-codesign
  artifacts:
    paths:
      - build/ios/iphoneos/

deploy-web:
  stage: deploy
  script:
    - flutter build web --release
    - firebase deploy --only hosting
  only:
    - main
```

---

## Performance Optimization

### 1. Reduce App Size

**Android**:
```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
        }
    }
    
    splits {
        abi {
            enable true
            reset()
            include 'armeabi-v7a', 'arm64-v8a', 'x86_64'
            universalApk false
        }
    }
}
```

### 2. Optimize Images

Use optimized image formats:
- PNG for simple graphics
- WebP for better compression
- SVG for scalable graphics

### 3. Code Splitting

Use deferred loading:
```dart
import 'package:flutter/material.dart';
import 'heavy_feature.dart' deferred as heavy;

void loadHeavyFeature() async {
  await heavy.loadLibrary();
  // Use heavy feature
}
```

---

## Monitoring & Analytics

### Firebase Analytics

Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_analytics: ^10.7.0
```

Initialize:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

### Crash Reporting

```yaml
dependencies:
  firebase_crashlytics: ^3.4.0
```

```dart
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
```

---

## Security Checklist

- [ ] Remove all debug print statements
- [ ] Obfuscate code
- [ ] Use ProGuard rules
- [ ] Implement SSL pinning
- [ ] Secure API keys in environment variables
- [ ] Enable app signing
- [ ] Implement biometric authentication if needed
- [ ] Add runtime security checks
- [ ] Regular security audits

---

## Post-Deployment

### 1. Monitor Performance
- Check crash reports daily
- Monitor API response times
- Track user engagement

### 2. Version Updates
```bash
# Increment version
flutter pub run cider version major  # 1.0.0 → 2.0.0
flutter pub run cider version minor  # 1.0.0 → 1.1.0
flutter pub run cider version patch  # 1.0.0 → 1.0.1
```

### 3. Hotfix Deployment
```bash
git checkout -b hotfix/critical-fix
# Make fixes
flutter build apk --release
# Deploy through respective channels
```

---

## Support & Maintenance

### Regular Tasks
- Weekly: Check analytics and crash reports
- Monthly: Update dependencies
- Quarterly: Security audit
- Yearly: Major version planning

### Useful Commands

```bash
# Clean build
flutter clean
flutter pub get

# Analyze code
flutter analyze

# Run tests
flutter test --coverage

# Check outdated packages
flutter pub outdated

# Update dependencies
flutter pub upgrade

# Format code
dart format .

# Check for breaking changes
flutter pub upgrade --dry-run
```

---

## Troubleshooting

### Common Build Issues

**Issue**: Build fails with "Gradle version too old"
```bash
cd android
./gradlew wrapper --gradle-version 7.6
```

**Issue**: iOS build fails with signing errors
- Verify team is selected in Xcode
- Check provisioning profiles
- Clean derived data: Xcode → Product → Clean Build Folder

**Issue**: Web build white screen
- Check base href in index.html
- Verify JavaScript is enabled
- Check browser console for errors

---

## Resources

- [Flutter Deployment Documentation](https://docs.flutter.dev/deployment)
- [Android Publishing Guide](https://developer.android.com/studio/publish)
- [iOS Distribution Guide](https://developer.apple.com/distribution/)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)

---

## Contact

For deployment support:
- Email: support@yourcompany.com
- Slack: #deployment-help
- Documentation: https://docs.yourcompany.com
