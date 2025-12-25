/// Model for customer information form (when CRM is not available)
class CustomerFormData {
  String firstName;
  String lastName;
  String email;
  String phone;
  String? alternatePhone;
  String? company;
  String? designation;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  String? notes;
  CustomerCategory? category;
  CustomerPriority priority;
  List<String> tags;
  Map<String, String> customFields;

  CustomerFormData({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.alternatePhone,
    this.company,
    this.designation,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.notes,
    this.category,
    this.priority = CustomerPriority.medium,
    this.tags = const [],
    this.customFields = const {},
  });

  String get fullName => '$firstName $lastName'.trim();

  bool get isValid =>
      firstName.isNotEmpty && (email.isNotEmpty || phone.isNotEmpty);

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'alternate_phone': alternatePhone,
      'company': company,
      'designation': designation,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'notes': notes,
      'category': category?.name,
      'priority': priority.name,
      'tags': tags,
      'custom_fields': customFields,
    };
  }

  factory CustomerFormData.fromJson(Map<String, dynamic> json) {
    return CustomerFormData(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      alternatePhone: json['alternate_phone'],
      company: json['company'],
      designation: json['designation'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      country: json['country'],
      notes: json['notes'],
      category: json['category'] != null
          ? CustomerCategory.values.firstWhere(
              (e) => e.name == json['category'],
              orElse: () => CustomerCategory.general,
            )
          : null,
      priority: CustomerPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => CustomerPriority.medium,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      customFields: Map<String, String>.from(json['custom_fields'] ?? {}),
    );
  }

  CustomerFormData copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? alternatePhone,
    String? company,
    String? designation,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? notes,
    CustomerCategory? category,
    CustomerPriority? priority,
    List<String>? tags,
    Map<String, String>? customFields,
  }) {
    return CustomerFormData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      company: company ?? this.company,
      designation: designation ?? this.designation,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      customFields: customFields ?? this.customFields,
    );
  }
}

enum CustomerCategory {
  general,
  vip,
  enterprise,
  small_business,
  individual,
  prospect,
  partner,
}

enum CustomerPriority {
  low,
  medium,
  high,
  urgent,
}

extension CustomerCategoryExtension on CustomerCategory {
  String get displayName {
    switch (this) {
      case CustomerCategory.general:
        return 'General';
      case CustomerCategory.vip:
        return 'VIP';
      case CustomerCategory.enterprise:
        return 'Enterprise';
      case CustomerCategory.small_business:
        return 'Small Business';
      case CustomerCategory.individual:
        return 'Individual';
      case CustomerCategory.prospect:
        return 'Prospect';
      case CustomerCategory.partner:
        return 'Partner';
    }
  }
}

extension CustomerPriorityExtension on CustomerPriority {
  String get displayName {
    switch (this) {
      case CustomerPriority.low:
        return 'Low';
      case CustomerPriority.medium:
        return 'Medium';
      case CustomerPriority.high:
        return 'High';
      case CustomerPriority.urgent:
        return 'Urgent';
    }
  }
}
