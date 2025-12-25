/// Model class representing call information
class CallInfo {
  final String callId;
  final String phoneNumber;
  final String? callerName;
  final DateTime callStartTime;
  final CallDirection direction;
  final CallStatus status;
  final String? agentId;
  final String? agentName;
  final Duration? duration;
  final String? notes;
  final CrmData? crmData;

  CallInfo({
    required this.callId,
    required this.phoneNumber,
    this.callerName,
    required this.callStartTime,
    required this.direction,
    required this.status,
    this.agentId,
    this.agentName,
    this.duration,
    this.notes,
    this.crmData,
  });

  /// Check if CRM data is available
  bool get hasCrmData => crmData != null;

  /// Factory constructor for creating CallInfo from JSON
  factory CallInfo.fromJson(Map<String, dynamic> json) {
    return CallInfo(
      callId: json['call_id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      callerName: json['caller_name'],
      callStartTime: DateTime.tryParse(json['call_start_time'] ?? '') ?? DateTime.now(),
      direction: CallDirection.values.firstWhere(
        (e) => e.name == json['direction'],
        orElse: () => CallDirection.inbound,
      ),
      status: CallStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CallStatus.active,
      ),
      agentId: json['agent_id'],
      agentName: json['agent_name'],
      duration: json['duration'] != null ? Duration(seconds: json['duration']) : null,
      notes: json['notes'],
      crmData: json['crm_data'] != null ? CrmData.fromJson(json['crm_data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'call_id': callId,
      'phone_number': phoneNumber,
      'caller_name': callerName,
      'call_start_time': callStartTime.toIso8601String(),
      'direction': direction.name,
      'status': status.name,
      'agent_id': agentId,
      'agent_name': agentName,
      'duration': duration?.inSeconds,
      'notes': notes,
      'crm_data': crmData?.toJson(),
    };
  }
}

/// Enum for call direction
enum CallDirection {
  inbound,
  outbound,
}

/// Enum for call status
enum CallStatus {
  active,
  onHold,
  completed,
  missed,
  transferred,
}

/// Model class representing CRM data
class CrmData {
  final String crmId;
  final String crmType;
  final String? customerId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? company;
  final String? designation;
  final String? accountStatus;
  final double? accountValue;
  final DateTime? lastInteraction;
  final List<CrmField> customFields;
  final List<CrmTicket>? tickets;
  final List<CrmNote>? notes;
  final Map<String, dynamic>? additionalData;

  CrmData({
    required this.crmId,
    required this.crmType,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.company,
    this.designation,
    this.accountStatus,
    this.accountValue,
    this.lastInteraction,
    this.customFields = const [],
    this.tickets,
    this.notes,
    this.additionalData,
  });

  factory CrmData.fromJson(Map<String, dynamic> json) {
    return CrmData(
      crmId: json['crm_id'] ?? '',
      crmType: json['crm_type'] ?? 'generic',
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      customerEmail: json['customer_email'],
      customerPhone: json['customer_phone'],
      company: json['company'],
      designation: json['designation'],
      accountStatus: json['account_status'],
      accountValue: json['account_value']?.toDouble(),
      lastInteraction: json['last_interaction'] != null
          ? DateTime.tryParse(json['last_interaction'])
          : null,
      customFields: (json['custom_fields'] as List<dynamic>?)
              ?.map((e) => CrmField.fromJson(e))
              .toList() ??
          [],
      tickets: (json['tickets'] as List<dynamic>?)
          ?.map((e) => CrmTicket.fromJson(e))
          .toList(),
      notes: (json['notes'] as List<dynamic>?)
          ?.map((e) => CrmNote.fromJson(e))
          .toList(),
      additionalData: json['additional_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crm_id': crmId,
      'crm_type': crmType,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'company': company,
      'designation': designation,
      'account_status': accountStatus,
      'account_value': accountValue,
      'last_interaction': lastInteraction?.toIso8601String(),
      'custom_fields': customFields.map((e) => e.toJson()).toList(),
      'tickets': tickets?.map((e) => e.toJson()).toList(),
      'notes': notes?.map((e) => e.toJson()).toList(),
      'additional_data': additionalData,
    };
  }
}

/// Model for dynamic CRM fields
class CrmField {
  final String key;
  final String label;
  final String value;
  final CrmFieldType type;
  final bool isEditable;

  CrmField({
    required this.key,
    required this.label,
    required this.value,
    this.type = CrmFieldType.text,
    this.isEditable = false,
  });

  factory CrmField.fromJson(Map<String, dynamic> json) {
    return CrmField(
      key: json['key'] ?? '',
      label: json['label'] ?? '',
      value: json['value']?.toString() ?? '',
      type: CrmFieldType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CrmFieldType.text,
      ),
      isEditable: json['is_editable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'value': value,
      'type': type.name,
      'is_editable': isEditable,
    };
  }
}

enum CrmFieldType {
  text,
  number,
  email,
  phone,
  date,
  currency,
  dropdown,
  boolean,
}

/// Model for CRM tickets
class CrmTicket {
  final String ticketId;
  final String title;
  final String status;
  final String priority;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CrmTicket({
    required this.ticketId,
    required this.title,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.updatedAt,
  });

  factory CrmTicket.fromJson(Map<String, dynamic> json) {
    return CrmTicket(
      ticketId: json['ticket_id'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? 'open',
      priority: json['priority'] ?? 'medium',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'title': title,
      'status': status,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// Model for CRM notes
class CrmNote {
  final String noteId;
  final String content;
  final String author;
  final DateTime createdAt;

  CrmNote({
    required this.noteId,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory CrmNote.fromJson(Map<String, dynamic> json) {
    return CrmNote(
      noteId: json['note_id'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note_id': noteId,
      'content': content,
      'author': author,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
