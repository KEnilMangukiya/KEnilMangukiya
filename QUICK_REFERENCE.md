# 🚀 Developer Quick Reference

## Instant Commands

```bash
# Setup
flutter pub get                 # Install dependencies
flutter doctor                  # Check environment

# Development
flutter run                     # Run app
flutter run -d chrome          # Run on web
flutter run --release          # Run release mode
r                              # Hot reload (while running)
R                              # Hot restart (while running)

# Testing
flutter test                   # Run all tests
flutter test --coverage        # With coverage

# Code Quality
flutter analyze                # Static analysis
dart format lib/               # Format code

# Build
flutter build apk              # Android APK
flutter build appbundle        # Android Bundle
flutter build ios              # iOS build
flutter build web              # Web build

# Clean
flutter clean                  # Clean build files
```

---

## File Quick Access

| What | Where |
|------|-------|
| Main app | `lib/main.dart` |
| Main screen | `lib/screens/call_info_screen.dart` |
| CRM view | `lib/widgets/crm_info_view.dart` |
| Form view | `lib/widgets/customer_form_view.dart` |
| CRM service | `lib/services/crm_service.dart` |
| Models | `lib/models/*.dart` |
| Tests | `test/**/*.dart` |

---

## Key Code Locations

### Change Theme Colors
**File**: `lib/main.dart` (line 18)
```dart
seedColor: const Color(0xFF6366F1), // Change this
```

### Modify API Behavior
**File**: `lib/services/crm_service.dart` (line 11)
```dart
if (random >= 3) {  // Adjust success rate here
```

### Update Sample Data
**File**: `lib/services/crm_service.dart` (line 19)
```dart
return CRMData(
  customerId: 'CRM-...', // Modify sample data
```

### Form Validation Rules
**File**: `lib/widgets/customer_form_view.dart` (line 87+)
```dart
validator: (value) {
  // Add custom validation
}
```

---

## Common Customizations

### 1. Change App Name
- `pubspec.yaml` (line 1): `name: your_app_name`
- `android/app/src/main/AndroidManifest.xml`: `android:label`
- `ios/Runner/Info.plist`: `CFBundleDisplayName`

### 2. Change Color Scheme
Edit `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFFYOURCOLOR),
),
```

### 3. Add New Form Field
In `lib/widgets/customer_form_view.dart`:
1. Add controller: `final _newController = TextEditingController();`
2. Add field: `_buildTextField(...)`
3. Dispose: `_newController.dispose();`
4. Use value: `_newController.text`

### 4. Add New Tab
In `lib/widgets/crm_info_view.dart`:
1. Update tab count: `TabController(length: 4, vsync: this);`
2. Add tab: `Tab(text: 'New Tab')`
3. Add content: Widget in `TabBarView`

### 5. Change API Delay
In `lib/services/crm_service.dart`:
```dart
await Future.delayed(const Duration(seconds: 2)); // Change duration
```

---

## Widget Tree

```
MaterialApp
└── CallInfoScreen (Stateful)
    ├── Header (Container)
    ├── SearchBar (Container)
    └── Content (Expanded)
        ├── WelcomeScreen (if !searched)
        ├── CRMInfoView (if customer found)
        │   ├── CallStatusBar
        │   ├── CustomerHeader
        │   ├── QuickStats (3 cards)
        │   ├── TabBar (3 tabs)
        │   ├── TabBarView
        │   │   ├── CallHistoryTab
        │   │   ├── OrdersTab
        │   │   └── NotesTab
        │   └── ActionButtons
        └── CustomerFormView (if not found)
            ├── AlertBanner
            ├── Form
            │   ├── PersonalSection
            │   ├── AddressSection
            │   └── CallInfoSection
            └── ActionButtons
```

---

## State Flow

```
App Start
   ↓
WelcomeScreen (initial)
   ↓
User enters phone → clicks search
   ↓
isLoading = true (show spinner)
   ↓
CRM Service API call (2s delay)
   ↓
   ├─→ Customer Found (70%)
   │   └─→ Show CRMInfoView
   │       └─→ End Call → Back to search
   │
   └─→ Not Found (30%)
       └─→ Show CustomerFormView
           ├─→ Cancel → Back to search
           └─→ Save → Success → Back to search
```

---

## Data Models Quick Ref

### CRMData
```dart
CRMData(
  customerId: String,
  name: String,
  email: String,
  phone: String,
  address: String,
  customerType: String,     // "Premium", "VIP", "Regular"
  lastContact: DateTime,
  totalCalls: int,
  callHistory: List<CallHistory>,
  recentOrders: List<Order>,
  accountStatus: String,    // "Active", "Inactive"
  totalSpent: double,
  preferredLanguage: String,
  notes: String,
)
```

### CustomerInfo
```dart
CustomerInfo(
  firstName: String,
  lastName: String,
  email: String,
  phone: String,
  address: String,
  city: String,
  state: String,
  zipCode: String,
  country: String,
  customerType: String,     // "New", "Existing", "VIP"
  callPurpose: String,      // "Inquiry", "Support", etc.
  callNotes: String,
  followUpDate: String,
  priority: String,         // "Low", "Medium", "High", "Urgent"
  customFields: Map<String, String>,
)
```

---

## Animation Timings

| Animation | Duration | Curve |
|-----------|----------|-------|
| View fade | 600ms | easeInOut |
| Tab switch | 300ms | easeInOut |
| Button press | 150ms | easeOut |
| Loading | Infinite | linear |
| Call pulse | 1000ms | ease |

---

## Color Reference

```dart
// Primary
Color(0xFF6366F1)  // Indigo
Color(0xFF8B5CF6)  // Purple

// Status
Color(0xFF10B981)  // Green (success)
Color(0xFFEAB308)  // Gold (premium)
Color(0xFFEF4444)  // Red (danger)
Color(0xFFFB923C)  // Orange (warning)

// Neutral
Color(0xFF1F2937)  // Gray 900 (text)
Color(0xFF6B7280)  // Gray 600 (secondary)
Color(0xFFE5E7EB)  // Gray 200 (border)
Color(0xFFF9FAFB)  // Gray 50 (bg)
```

---

## Spacing System

```dart
4px   // XS - Tight spacing
8px   // S  - Close spacing
12px  // M  - Standard spacing
16px  // L  - Comfortable spacing
24px  // XL - Section spacing
32px  // XXL - Major spacing
```

---

## Common Issues & Fixes

### Build Errors
```bash
flutter clean && flutter pub get && flutter run
```

### Gradle Issues (Android)
```bash
cd android && ./gradlew clean && cd ..
```

### iOS Pods Issues
```bash
cd ios && pod install --repo-update && cd ..
```

### Hot Reload Not Working
Press `R` (capital R) for hot restart

### Dependencies Error
```bash
flutter pub upgrade --major-versions
```

---

## Testing Checklist

- [ ] Search functionality works
- [ ] Customer found view displays correctly
- [ ] All tabs work (History, Orders, Notes)
- [ ] Call timer runs
- [ ] Form validation works
- [ ] Required fields are validated
- [ ] Dropdowns work
- [ ] Date picker works
- [ ] Save customer works
- [ ] Cancel returns to search
- [ ] End call returns to search
- [ ] Animations are smooth
- [ ] No console errors
- [ ] Responsive on different sizes

---

## Build Checklist

- [ ] Update version in pubspec.yaml
- [ ] Update version in Android build.gradle
- [ ] Update version in iOS Info.plist
- [ ] Test on real devices
- [ ] Run flutter analyze
- [ ] Run all tests
- [ ] Test release build
- [ ] Check app size
- [ ] Verify icons
- [ ] Check splash screen
- [ ] Test on different OS versions

---

## Documentation Map

```
README.md              → Start here
GETTING_STARTED.md     → Setup guide
PROJECT_SUMMARY.md     → Overview
FEATURES.md            → What it does
DESIGN.md              → How it looks
SCREENSHOTS.md         → Visual guide
API_INTEGRATION.md     → Connect to API
DEPLOYMENT.md          → Build & release
CHANGELOG.md           → Version history
QUICK_REFERENCE.md     → This file
```

---

## Useful Snippets

### Add Loading State
```dart
setState(() {
  _isLoading = true;
});
// Do async work
setState(() {
  _isLoading = false;
});
```

### Show SnackBar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Message')),
);
```

### Navigate to Screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);
```

### Format Date
```dart
import 'package:intl/intl.dart';
DateFormat('MMM dd, yyyy').format(date);
```

### Validate Email
```dart
validator: (value) {
  if (value == null || !value.contains('@')) {
    return 'Enter valid email';
  }
  return null;
}
```

---

## Performance Tips

1. Use `const` constructors where possible
2. Avoid rebuilding entire widget tree
3. Use `ListView.builder` for long lists
4. Implement pagination for large datasets
5. Cache images
6. Minimize setState scope
7. Use `compute` for heavy operations
8. Profile with DevTools

---

## Git Workflow

```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes
git add .
git commit -m "feat: add new feature"

# Push
git push origin feature/my-feature

# Create pull request
# Merge after review
```

---

## Package Updates

```bash
# Check outdated
flutter pub outdated

# Update
flutter pub upgrade

# Update to major versions
flutter pub upgrade --major-versions
```

---

## Debug Shortcuts (VS Code)

- `F5` - Start debugging
- `Shift+F5` - Stop debugging
- `Ctrl+F5` - Run without debugging
- `F10` - Step over
- `F11` - Step into
- `Shift+F11` - Step out

---

## Keyboard Shortcuts (While Running)

- `r` - Hot reload
- `R` - Hot restart
- `p` - Performance overlay
- `w` - Widget inspector
- `s` - Screenshot
- `q` - Quit

---

## Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Dart Docs**: https://dart.dev/guides
- **Material 3**: https://m3.material.io
- **Pub.dev**: https://pub.dev
- **Flutter Gallery**: https://gallery.flutter.dev

---

**Keep this file handy for quick development reference!** 📌
