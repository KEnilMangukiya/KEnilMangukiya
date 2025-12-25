# Getting Started Guide

Welcome to the Call Info Manager application! This guide will help you set up and run the application.

## Quick Start

### Step 1: Prerequisites

Ensure you have Flutter installed on your system:

```bash
# Check Flutter installation
flutter --version

# If not installed, visit: https://flutter.dev/docs/get-started/install
```

You should see output similar to:
```
Flutter 3.16.0 • channel stable
```

### Step 2: Clone the Repository

```bash
# If using Git
git clone <your-repository-url>
cd workspace

# Or simply navigate to your project directory
cd /workspace
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

This will download all required packages listed in `pubspec.yaml`.

### Step 4: Run the Application

#### On Android Device/Emulator
```bash
# List available devices
flutter devices

# Run on connected device
flutter run
```

#### On iOS Device/Simulator (macOS only)
```bash
# Open iOS simulator
open -a Simulator

# Run the app
flutter run
```

#### On Web Browser
```bash
flutter run -d chrome
```

#### On Desktop
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

---

## Project Structure

```
workspace/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── screens/
│   │   └── call_info_screen.dart    # Main screen with search
│   ├── widgets/
│   │   ├── crm_info_view.dart       # Customer found view
│   │   └── customer_form_view.dart  # New customer form
│   ├── models/
│   │   ├── crm_data_model.dart      # CRM data structures
│   │   └── customer_model.dart      # Customer info model
│   └── services/
│       └── crm_service.dart         # CRM API service
├── test/                            # Unit tests
├── android/                         # Android specific files
├── ios/                            # iOS specific files
├── web/                            # Web specific files
└── pubspec.yaml                    # Dependencies
```

---

## Understanding the Application Flow

### 1. Welcome Screen
When you first launch the app, you'll see:
- A search bar to enter phone numbers or customer IDs
- Feature highlights showing what the app can do
- A search button to look up customers

### 2. Customer Search
Enter a phone number (e.g., `+1234567890`) and click search:
- The app will query the CRM system
- Loading indicator shows while searching
- Results appear automatically

### 3. Two Possible Outcomes

#### A. Customer Found (70% in demo mode)
You'll see:
- **Call Status Bar**: Live timer showing call duration
- **Customer Profile**: Complete customer information with badge
- **Quick Stats**: Total calls, spending, and account status
- **Tabbed Interface**:
  - **History Tab**: Past call records
  - **Orders Tab**: Recent purchases
  - **Notes Tab**: Existing notes and add new ones
- **Actions**: Save notes or end call

#### B. Customer Not Found (30% in demo mode)
You'll see:
- **Alert Banner**: "Customer Not Found" notification
- **Registration Form** with sections:
  - Personal Information (name, email, phone)
  - Address (street, city, state, ZIP, country)
  - Call Information (type, purpose, priority, notes)
- **Actions**: Cancel or save new customer

---

## Features Overview

### 🔍 Smart Search
- Search by phone number or customer ID
- Instant CRM lookup
- Clear feedback for found/not found

### 📞 Active Call Management
- Live call timer
- Real-time duration tracking
- Visual call status indicator

### 👤 Customer Profiles
- Complete contact information
- Customer type badges (Premium, VIP, Regular)
- Account status and history
- Purchase history

### 📝 Call Notes
- Add notes during calls
- View historical notes
- Save notes to CRM

### ➕ New Customer Registration
- Comprehensive form
- Form validation
- Dropdown selectors for standardized data
- Date picker for follow-ups

### 🎨 Beautiful UI
- Modern Material Design 3
- Smooth animations
- Color-coded information
- Responsive design

---

## Using the Demo Mode

The app includes a simulated CRM service for testing:

### Simulated Behavior
- **70% success rate**: Most searches return sample customer data
- **30% not found**: Some searches trigger the new customer form
- **Automatic data**: Sample customer information is generated
- **Network delay**: 2-second delay simulates real API calls

### Sample Customer Data
When found, you'll see:
- Name: John Doe
- Email: john.doe@email.com
- Phone: Your searched number
- Address: 123 Main Street, Apt 4B, Downtown District
- Customer Type: Premium
- Multiple call history records
- Recent orders

### Testing Different Scenarios

**To test customer found:**
Search for any phone number multiple times - eventually it will return data

**To test customer not found:**
Keep searching - about 30% of attempts will show the form

**To test form validation:**
1. Click search to show the form
2. Try submitting without filling fields
3. See validation errors
4. Fill in required fields and submit

---

## Customization

### Change Theme Colors

Edit `lib/main.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF6366F1), // Change to your color
  brightness: Brightness.light,
),
```

### Modify Sample Data

Edit `lib/services/crm_service.dart`:

```dart
// Change the customer data returned
return CRMData(
  customerId: 'CRM-001',
  name: 'Your Custom Name',
  email: 'custom@email.com',
  // ... modify other fields
);
```

### Adjust Success Rate

In `lib/services/crm_service.dart`:

```dart
// Change this line to adjust found vs not found ratio
if (random >= 3) {  // Currently 70% success rate
  // Change to >= 5 for 50% success rate
  // Change to >= 1 for 90% success rate
```

---

## Development Tips

### Hot Reload
While the app is running, save any file to trigger hot reload:
- Press `r` in terminal to reload
- Press `R` to restart app
- Press `q` to quit

### Debug Mode Features
In debug mode, you have access to:
- Flutter Inspector (VS Code/Android Studio)
- Performance overlay: Press `P` in terminal
- Widget inspector overlay: Press `W`
- Frame rendering stats: Press `S`

### Common Commands

```bash
# Run with verbose logging
flutter run -v

# Run in release mode (faster)
flutter run --release

# Run tests
flutter test

# Analyze code for issues
flutter analyze

# Format code
dart format lib/

# Clean build files
flutter clean

# Update dependencies
flutter pub upgrade
```

---

## Integrating with Real CRM

To connect to your actual CRM system:

1. **Read API Integration Guide**
   See `API_INTEGRATION.md` for detailed instructions

2. **Add HTTP Package**
   ```yaml
   dependencies:
     dio: ^5.4.0  # or http: ^1.1.0
   ```

3. **Update CRM Service**
   Replace simulated methods in `lib/services/crm_service.dart`

4. **Configure API URL**
   Set your CRM API endpoint

5. **Add Authentication**
   Implement your authentication mechanism

6. **Test Integration**
   Run tests with real API calls

---

## Troubleshooting

### Issue: Flutter not found
**Solution**: Install Flutter SDK from https://flutter.dev

### Issue: Gradle build failed (Android)
**Solution**: 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: CocoaPods error (iOS)
**Solution**:
```bash
cd ios
pod install --repo-update
cd ..
flutter run
```

### Issue: Dependencies conflict
**Solution**:
```bash
flutter clean
rm pubspec.lock
flutter pub get
```

### Issue: App won't install on device
**Solution**:
- Check USB debugging is enabled (Android)
- Trust computer on device (iOS)
- Check device is listed: `flutter devices`
- Try: `flutter run --verbose` for detailed errors

---

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/customer_model_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Building for Production

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS
```bash
flutter build ios --release
```
Then open Xcode to create archive

### Web
```bash
flutter build web --release
```
Output: `build/web/`

---

## Next Steps

1. **Explore the UI**: Click through all screens and features
2. **Read Documentation**: Check out other `.md` files:
   - `DESIGN.md` - UI/UX design details
   - `API_INTEGRATION.md` - Connect to real CRM
   - `DEPLOYMENT.md` - Deploy to stores
   - `SCREENSHOTS.md` - Visual guide
3. **Customize**: Modify colors, text, and features
4. **Test**: Run tests and try different scenarios
5. **Deploy**: Build and release your app

---

## Getting Help

### Documentation
- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Material Design: https://m3.material.io

### Resources
- Flutter Community: https://flutter.dev/community
- Stack Overflow: Tag with `flutter`
- GitHub Issues: Report bugs in your repository

### Code Examples
All major features are well-commented in the code:
- Check widget comments for UI explanations
- Read model comments for data structure
- Review service comments for API integration

---

## Performance Tips

1. **Use Release Mode** for testing performance
   ```bash
   flutter run --release
   ```

2. **Profile Your App**
   ```bash
   flutter run --profile
   ```

3. **Check Build Size**
   ```bash
   flutter build apk --analyze-size
   ```

4. **Optimize Images**
   - Use WebP format
   - Compress images before adding
   - Use appropriate resolutions

---

## Best Practices

✅ **Always test on real devices** before releasing
✅ **Use hot reload** during development for faster iteration
✅ **Write tests** for critical business logic
✅ **Follow Flutter style guide** for consistent code
✅ **Use const constructors** where possible for performance
✅ **Handle errors gracefully** with try-catch blocks
✅ **Add loading states** for async operations
✅ **Validate user input** before processing
✅ **Keep widgets small** and focused on single responsibility
✅ **Use meaningful variable names** for better readability

---

## Support

For technical support:
- Check existing documentation files
- Review code comments
- Search Flutter documentation
- Ask on Flutter community forums

---

**Congratulations!** You're now ready to use and customize the Call Info Manager application. Happy coding! 🚀
