class CustomerInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String customerType;
  final String callPurpose;
  final String callNotes;
  final String followUpDate;
  final String priority;
  final Map<String, String> customFields;

  CustomerInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.customerType,
    required this.callPurpose,
    required this.callNotes,
    required this.followUpDate,
    required this.priority,
    required this.customFields,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
      customerType: json['customerType'] ?? 'New',
      callPurpose: json['callPurpose'] ?? '',
      callNotes: json['callNotes'] ?? '',
      followUpDate: json['followUpDate'] ?? '',
      priority: json['priority'] ?? 'Medium',
      customFields: Map<String, String>.from(json['customFields'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'customerType': customerType,
      'callPurpose': callPurpose,
      'callNotes': callNotes,
      'followUpDate': followUpDate,
      'priority': priority,
      'customFields': customFields,
    };
  }

  String get fullName => '$firstName $lastName';
}
