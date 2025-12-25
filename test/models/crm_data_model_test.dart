import 'package:flutter_test/flutter_test.dart';
import 'package:call_info_app/models/crm_data_model.dart';

void main() {
  group('CRMData Model Tests', () {
    test('should create CRMData from JSON', () {
      final json = {
        'customerId': 'CRM-001',
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'address': '123 Main St',
        'customerType': 'Premium',
        'lastContact': '2024-12-01T10:00:00.000Z',
        'totalCalls': 10,
        'callHistory': [],
        'recentOrders': [],
        'accountStatus': 'Active',
        'totalSpent': 1500.50,
        'preferredLanguage': 'English',
        'notes': 'VIP customer',
      };

      final crmData = CRMData.fromJson(json);

      expect(crmData.customerId, 'CRM-001');
      expect(crmData.name, 'John Doe');
      expect(crmData.totalCalls, 10);
      expect(crmData.totalSpent, 1500.50);
    });

    test('should create CallHistory from JSON', () {
      final json = {
        'date': '2024-12-01T10:00:00.000Z',
        'duration': '05:30',
        'type': 'Incoming',
        'status': 'Completed',
        'notes': 'Customer inquiry',
      };

      final callHistory = CallHistory.fromJson(json);

      expect(callHistory.duration, '05:30');
      expect(callHistory.type, 'Incoming');
      expect(callHistory.status, 'Completed');
    });

    test('should create Order from JSON', () {
      final json = {
        'orderId': 'ORD-001',
        'date': '2024-12-01T10:00:00.000Z',
        'amount': 299.99,
        'status': 'Delivered',
        'product': 'Premium Package',
      };

      final order = Order.fromJson(json);

      expect(order.orderId, 'ORD-001');
      expect(order.amount, 299.99);
      expect(order.status, 'Delivered');
      expect(order.product, 'Premium Package');
    });
  });
}
