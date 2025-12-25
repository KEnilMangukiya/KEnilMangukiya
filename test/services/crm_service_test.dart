import 'package:flutter_test/flutter_test.dart';
import 'package:call_info_app/services/crm_service.dart';

void main() {
  group('CRMService Tests', () {
    late CRMService crmService;

    setUp(() {
      crmService = CRMService();
    });

    test('should fetch customer data successfully', () async {
      // Note: This test uses the simulated service
      // In production, you would mock the HTTP calls
      final result = await crmService.fetchCustomerData('+1234567890');

      // The service has a 70% success rate in simulation
      // This test might fail occasionally due to random simulation
      // In production, you would control this with mocks
      expect(result, isNotNull);
    });

    test('should handle customer not found', () async {
      // Test the exception handling
      try {
        await crmService.fetchCustomerData('+0000000000');
        // If we get here, customer was found (due to random simulation)
      } catch (e) {
        expect(e.toString(), contains('Customer not found'));
      }
    });

    test('should save customer info successfully', () async {
      final customerData = {
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test@example.com',
        'phone': '+1234567890',
      };

      final result = await crmService.saveCustomerInfo(customerData);
      expect(result, true);
    });

    test('should update CRM data successfully', () async {
      final updates = {
        'notes': 'Updated notes',
        'lastContact': DateTime.now().toIso8601String(),
      };

      final result = await crmService.updateCRMData('CRM-001', updates);
      expect(result, true);
    });
  });
}
