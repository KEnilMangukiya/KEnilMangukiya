/// Utility class for form validation
class FormValidators {
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates phone number format
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    // Remove common formatting characters
    final cleanedPhone = value.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
    
    // Check if it starts with + and has 10-15 digits
    if (cleanedPhone.startsWith('+')) {
      if (cleanedPhone.length < 11 || cleanedPhone.length > 16) {
        return 'Please enter a valid phone number';
      }
    } else {
      // Domestic format (10 digits typically)
      if (cleanedPhone.length < 10 || cleanedPhone.length > 15) {
        return 'Please enter a valid phone number';
      }
    }
    
    // Check if all characters are digits (after removing +)
    final digitsOnly = cleanedPhone.replaceFirst('+', '');
    if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
      return 'Phone number should contain only digits';
    }
    
    return null;
  }

  /// Validates required fields
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates minimum length
  static String? validateMinLength(String? value, int minLength, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Let required validator handle empty check
    }
    
    if (value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validates maximum length
  static String? validateMaxLength(String? value, int maxLength, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    if (value.trim().length > maxLength) {
      return '$fieldName must be no more than $maxLength characters';
    }
    return null;
  }

  /// Validates ZIP/postal code format
  static String? validateZipCode(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    // US ZIP code format: 5 digits or 5+4 digits
    final usZipRegex = RegExp(r'^\d{5}(-\d{4})?$');
    // Canadian postal code format
    final caPostalRegex = RegExp(r'^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$');
    // UK postal code format
    final ukPostalRegex = RegExp(r'^[A-Za-z]{1,2}\d[A-Za-z\d]? ?\d[A-Za-z]{2}$');
    
    if (!usZipRegex.hasMatch(value) && 
        !caPostalRegex.hasMatch(value) && 
        !ukPostalRegex.hasMatch(value)) {
      // Accept generic format for other countries
      if (value.length < 3 || value.length > 10) {
        return 'Please enter a valid postal code';
      }
    }
    
    return null;
  }

  /// Validates URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Combines multiple validators
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}

/// Extension for easy form field formatting
extension StringFormattingExtension on String {
  /// Formats a phone number for display
  String formatPhoneNumber() {
    final digits = replaceAll(RegExp(r'\D'), '');
    
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    
    return this;
  }

  /// Capitalizes the first letter of each word
  String toTitleCase() {
    return split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  /// Returns initials from a name
  String getInitials({int count = 2}) {
    final words = trim().split(' ').where((w) => w.isNotEmpty);
    return words
        .take(count)
        .map((w) => w[0].toUpperCase())
        .join();
  }
}
