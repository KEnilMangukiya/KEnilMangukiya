# Call Info Manager - Flutter App

A beautiful Flutter application for creating and managing call information with dynamic CRM integration.

## Features

✨ **Dynamic CRM Integration**
- Automatically detects CRM calls based on call ID
- Displays comprehensive CRM information in a beautiful card layout
- Shows account details, contact information, and follow-up dates

📝 **Customer Information Form**
- Clean, modern form UI for adding customer details
- Validates phone numbers and email addresses
- Saves customer information with all relevant details

🎨 **Modern UI/UX Design**
- Gradient backgrounds and smooth animations
- Material Design 3 components
- Responsive layout with beautiful shadows and borders
- Intuitive user interface

## Project Structure

```
lib/
├── main.dart                    # App entry point with home screen
├── models/
│   ├── call_info.dart          # CallInfo model
│   └── customer.dart           # Customer model
├── screens/
│   └── call_info_screen.dart   # Main call info creation screen
└── widgets/
    ├── dynamic_crm_display.dart    # CRM information display widget
    └── customer_detail_form.dart   # Customer form widget
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Usage

### Creating a CRM Call Info

1. From the home screen, tap "Create Call Info (CRM)"
2. The app will automatically detect it's a CRM call
3. Fill in the call information (Call ID, Call Type, Date, Notes)
4. CRM information will be displayed automatically
5. Save the call info

### Creating a Regular Call Info

1. From the home screen, tap "Create Call Info"
2. Fill in the call information
3. A customer detail form will appear
4. Enter customer information:
   - Full Name (required)
   - Phone Number (required)
   - Email Address (optional)
   - Company Name (optional)
   - Address (optional)
   - Additional Notes (optional)
5. Save both call info and customer information

## Key Components

### CallInfoScreen
The main screen that handles:
- Call information input
- CRM detection logic
- Conditional rendering of CRM display or customer form
- Form validation and submission

### DynamicCrmDisplay
Displays CRM information in a beautiful card format with:
- Account details
- Contact information
- Business metrics
- Status and priority indicators

### CustomerDetailForm
A comprehensive form for capturing customer information with:
- Field validation
- Modern input styling
- Save functionality

## Customization

### Changing CRM Detection Logic

Edit the `_checkIfCRM()` method in `call_info_screen.dart` to implement your own CRM detection logic:

```dart
void _checkIfCRM() {
  // Add your CRM detection logic here
  final isCRM = widget.isCRM ?? (widget.callId?.toLowerCase().contains('crm') ?? false);
  // ...
}
```

### Modifying CRM Data Structure

Update the `crmData` map in `_checkIfCRM()` method to match your CRM system's data structure.

### Styling

The app uses a teal color scheme. To change colors, modify the `ThemeData` in `main.dart` and color values throughout the widgets.

## Dependencies

- `flutter`: Flutter SDK
- `intl`: For date formatting
- `cupertino_icons`: iOS-style icons

## License

This project is open source and available for use.
