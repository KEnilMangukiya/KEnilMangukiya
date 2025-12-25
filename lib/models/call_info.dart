class CallInfo {
  final String? id;
  final String? callId;
  final String? customerName;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime? callDate;
  final String? callType;
  final bool isCRM;
  final Map<String, dynamic>? crmData;

  CallInfo({
    this.id,
    this.callId,
    this.customerName,
    this.phoneNumber,
    this.email,
    this.address,
    this.notes,
    this.callDate,
    this.callType,
    this.isCRM = false,
    this.crmData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'callId': callId,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'notes': notes,
      'callDate': callDate?.toIso8601String(),
      'callType': callType,
      'isCRM': isCRM,
      'crmData': crmData,
    };
  }

  factory CallInfo.fromJson(Map<String, dynamic> json) {
    return CallInfo(
      id: json['id'],
      callId: json['callId'],
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
      notes: json['notes'],
      callDate: json['callDate'] != null ? DateTime.parse(json['callDate']) : null,
      callType: json['callType'],
      isCRM: json['isCRM'] ?? false,
      crmData: json['crmData'],
    );
  }

  CallInfo copyWith({
    String? id,
    String? callId,
    String? customerName,
    String? phoneNumber,
    String? email,
    String? address,
    String? notes,
    DateTime? callDate,
    String? callType,
    bool? isCRM,
    Map<String, dynamic>? crmData,
  }) {
    return CallInfo(
      id: id ?? this.id,
      callId: callId ?? this.callId,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      callDate: callDate ?? this.callDate,
      callType: callType ?? this.callType,
      isCRM: isCRM ?? this.isCRM,
      crmData: crmData ?? this.crmData,
    );
  }
}
