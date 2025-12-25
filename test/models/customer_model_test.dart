import 'package:flutter_test/flutter_test.dart';
import 'package:call_info_app/models/customer_model.dart';

void main() {
  group('CustomerInfo Model Tests', () {
    test('should create CustomerInfo from JSON', () {
      final json = {
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'address': '123 Main St',
        'city': 'New York',
        'state': 'NY',
        'zipCode': '10001',
        'country': 'USA',
        'customerType': 'New',
        'callPurpose': 'Inquiry',
        'callNotes': 'Test notes',
        'followUpDate': '2024-12-31',
        'priority': 'High',
        'customFields': {},
      };

      final customer = CustomerInfo.fromJson(json);

      expect(customer.firstName, 'John');
      expect(customer.lastName, 'Doe');
      expect(customer.email, 'john@example.com');
      expect(customer.fullName, 'John Doe');
    });

    test('should convert CustomerInfo to JSON', () {
      final customer = CustomerInfo(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        phone: '+9876543210',
        address: '456 Oak Ave',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90001',
        country: 'USA',
        customerType: 'VIP',
        callPurpose: 'Support',
        callNotes: 'Important customer',
        followUpDate: '2024-12-25',
        priority: 'Urgent',
        customFields: {},
      );

      final json = customer.toJson();

      expect(json['firstName'], 'Jane');
      expect(json['lastName'], 'Smith');
      expect(json['email'], 'jane@example.com');
    });

    test('should return correct full name', () {
      final customer = CustomerInfo(
        firstName: 'Alice',
        lastName: 'Johnson',
        email: 'alice@example.com',
        phone: '+1111111111',
        address: '',
        city: '',
        state: '',
        zipCode: '',
        country: '',
        customerType: 'Regular',
        callPurpose: 'Order',
        callNotes: '',
        followUpDate: '',
        priority: 'Medium',
        customFields: {},
      );

      expect(customer.fullName, 'Alice Johnson');
    });
  });
}
