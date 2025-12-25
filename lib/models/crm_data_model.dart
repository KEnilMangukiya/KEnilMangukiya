class CRMData {
  final String customerId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String customerType;
  final DateTime lastContact;
  final int totalCalls;
  final List<CallHistory> callHistory;
  final List<Order> recentOrders;
  final String accountStatus;
  final double totalSpent;
  final String preferredLanguage;
  final String notes;

  CRMData({
    required this.customerId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.customerType,
    required this.lastContact,
    required this.totalCalls,
    required this.callHistory,
    required this.recentOrders,
    required this.accountStatus,
    required this.totalSpent,
    required this.preferredLanguage,
    required this.notes,
  });

  factory CRMData.fromJson(Map<String, dynamic> json) {
    return CRMData(
      customerId: json['customerId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      customerType: json['customerType'] ?? 'Regular',
      lastContact: DateTime.parse(json['lastContact'] ?? DateTime.now().toIso8601String()),
      totalCalls: json['totalCalls'] ?? 0,
      callHistory: (json['callHistory'] as List?)
          ?.map((e) => CallHistory.fromJson(e))
          .toList() ?? [],
      recentOrders: (json['recentOrders'] as List?)
          ?.map((e) => Order.fromJson(e))
          .toList() ?? [],
      accountStatus: json['accountStatus'] ?? 'Active',
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
      preferredLanguage: json['preferredLanguage'] ?? 'English',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'customerType': customerType,
      'lastContact': lastContact.toIso8601String(),
      'totalCalls': totalCalls,
      'callHistory': callHistory.map((e) => e.toJson()).toList(),
      'recentOrders': recentOrders.map((e) => e.toJson()).toList(),
      'accountStatus': accountStatus,
      'totalSpent': totalSpent,
      'preferredLanguage': preferredLanguage,
      'notes': notes,
    };
  }
}

class CallHistory {
  final DateTime date;
  final String duration;
  final String type;
  final String status;
  final String notes;

  CallHistory({
    required this.date,
    required this.duration,
    required this.type,
    required this.status,
    required this.notes,
  });

  factory CallHistory.fromJson(Map<String, dynamic> json) {
    return CallHistory(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      duration: json['duration'] ?? '0:00',
      type: json['type'] ?? 'Incoming',
      status: json['status'] ?? 'Completed',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'duration': duration,
      'type': type,
      'status': status,
      'notes': notes,
    };
  }
}

class Order {
  final String orderId;
  final DateTime date;
  final double amount;
  final String status;
  final String product;

  Order({
    required this.orderId,
    required this.date,
    required this.amount,
    required this.status,
    required this.product,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      product: json['product'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'date': date.toIso8601String(),
      'amount': amount,
      'status': status,
      'product': product,
    };
  }
}
