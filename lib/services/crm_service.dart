import '../models/crm_data_model.dart';

class CRMService {
  // Simulates fetching customer data from CRM
  // In production, this would be an actual API call
  Future<CRMData?> fetchCustomerData(String phoneOrId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate 70% chance of finding customer in CRM
    final random = DateTime.now().millisecondsSinceEpoch % 10;
    
    if (random >= 3) {
      // Customer found in CRM
      return CRMData(
        customerId: 'CRM-${phoneOrId.substring(0, 4)}',
        name: 'John Doe',
        email: 'john.doe@email.com',
        phone: phoneOrId,
        address: '123 Main Street, Apt 4B, Downtown District',
        customerType: 'Premium',
        lastContact: DateTime.now().subtract(const Duration(days: 15)),
        totalCalls: 24,
        callHistory: [
          CallHistory(
            date: DateTime.now().subtract(const Duration(days: 15)),
            duration: '12:34',
            type: 'Incoming',
            status: 'Completed',
            notes: 'Customer inquired about product features',
          ),
          CallHistory(
            date: DateTime.now().subtract(const Duration(days: 30)),
            duration: '8:15',
            type: 'Outgoing',
            status: 'Completed',
            notes: 'Follow-up on previous order',
          ),
          CallHistory(
            date: DateTime.now().subtract(const Duration(days: 45)),
            duration: '15:42',
            type: 'Incoming',
            status: 'Completed',
            notes: 'Technical support for installation',
          ),
        ],
        recentOrders: [
          Order(
            orderId: 'ORD-2024-001',
            date: DateTime.now().subtract(const Duration(days: 20)),
            amount: 299.99,
            status: 'Delivered',
            product: 'Premium Package',
          ),
          Order(
            orderId: 'ORD-2024-002',
            date: DateTime.now().subtract(const Duration(days: 60)),
            amount: 149.99,
            status: 'Delivered',
            product: 'Standard Package',
          ),
        ],
        accountStatus: 'Active',
        totalSpent: 1249.99,
        preferredLanguage: 'English',
        notes: 'VIP customer. Prefers email communication for non-urgent matters.',
      );
    } else {
      // Customer not found in CRM
      throw Exception('Customer not found in CRM');
    }
  }

  // Save new customer information
  Future<bool> saveCustomerInfo(Map<String, dynamic> customerData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // In production, this would be an actual API call to save the data
    print('Saving customer data: $customerData');
    
    return true;
  }

  // Update existing CRM data
  Future<bool> updateCRMData(String customerId, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Updating CRM for customer $customerId: $updates');
    return true;
  }
}
