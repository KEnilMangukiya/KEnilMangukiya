class Customer {
  final String? id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? address;
  final String? company;
  final String? notes;
  final DateTime? createdAt;

  Customer({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.address,
    this.company,
    this.notes,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'company': company,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
      company: json['company'],
      notes: json['notes'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
