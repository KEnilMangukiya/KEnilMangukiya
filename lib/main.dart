import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/call_info_model.dart';
import 'models/customer_form_model.dart';
import 'screens/call_info_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CallInfoApp());
}

class CallInfoApp extends StatelessWidget {
  const CallInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Info',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DemoScreen(),
    );
  }
}

/// Demo screen to showcase the Call Info functionality
class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  bool _showWithCrm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Call Info Demo',
                style: AppTheme.headingLarge,
              ),
              const SizedBox(height: AppTheme.spacingSM),
              const Text(
                'Choose a demo mode to see the call info screen',
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingXL),
              _buildDemoOption(
                title: 'With CRM Data',
                subtitle: 'Shows dynamic CRM integration with customer details',
                icon: Icons.hub_outlined,
                gradient: AppTheme.primaryGradient,
                isSelected: _showWithCrm,
                onTap: () => setState(() => _showWithCrm = true),
              ),
              const SizedBox(height: AppTheme.spacingMD),
              _buildDemoOption(
                title: 'Without CRM (New Customer)',
                subtitle: 'Shows manual customer form for agents',
                icon: Icons.person_add_outlined,
                gradient: AppTheme.warmGradient,
                isSelected: !_showWithCrm,
                onTap: () => setState(() => _showWithCrm = false),
              ),
              const Spacer(),
              _buildLaunchButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected ? AppTheme.shadowColored : AppTheme.shadowSmall,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: AppTheme.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.headingSmall),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTheme.bodySmall),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.surfaceMedium,
                  width: 2,
                ),
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaunchButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.shadowColored,
      ),
      child: ElevatedButton.icon(
        onPressed: _launchCallInfoScreen,
        icon: const Icon(Icons.call, color: Colors.white),
        label: const Text('Launch Call Info Screen'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMD),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _launchCallInfoScreen() {
    final callInfo = _showWithCrm
        ? _createCallInfoWithCrm()
        : _createCallInfoWithoutCrm();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CallInfoScreen(
          callInfo: callInfo,
          onCustomerSave: (data) {
            debugPrint('Customer saved: ${data.toJson()}');
          },
          onCrmRefresh: () {
            debugPrint('CRM refresh requested');
          },
          onEndCall: () {
            Navigator.of(context).pop();
          },
          onHoldCall: () {
            debugPrint('Call hold toggled');
          },
          onTransferCall: () {
            debugPrint('Transfer call requested');
          },
        ),
      ),
    );
  }

  CallInfo _createCallInfoWithCrm() {
    return CallInfo(
      callId: 'CALL-2024-001',
      phoneNumber: '+1 (555) 123-4567',
      callerName: 'John Smith',
      callStartTime: DateTime.now().subtract(const Duration(minutes: 5)),
      direction: CallDirection.inbound,
      status: CallStatus.active,
      agentId: 'AGT-001',
      agentName: 'Sarah Johnson',
      crmData: CrmData(
        crmId: 'CRM-12345',
        crmType: 'Salesforce',
        customerId: 'CUST-78901',
        customerName: 'John Smith',
        customerEmail: 'john.smith@techcorp.com',
        customerPhone: '+1 (555) 123-4567',
        company: 'TechCorp Industries',
        designation: 'Senior Manager',
        accountStatus: 'active',
        accountValue: 125000.00,
        lastInteraction: DateTime.now().subtract(const Duration(days: 7)),
        customFields: [
          CrmField(
            key: 'subscription_tier',
            label: 'Subscription Tier',
            value: 'Enterprise',
            type: CrmFieldType.dropdown,
            isEditable: false,
          ),
          CrmField(
            key: 'renewal_date',
            label: 'Renewal Date',
            value: '2025-06-15',
            type: CrmFieldType.date,
            isEditable: false,
          ),
          CrmField(
            key: 'contract_value',
            label: 'Contract Value',
            value: '\$125,000',
            type: CrmFieldType.currency,
            isEditable: false,
          ),
          CrmField(
            key: 'preferred_contact',
            label: 'Preferred Contact Method',
            value: 'Email',
            type: CrmFieldType.dropdown,
            isEditable: true,
          ),
          CrmField(
            key: 'timezone',
            label: 'Timezone',
            value: 'EST (UTC-5)',
            type: CrmFieldType.text,
            isEditable: true,
          ),
        ],
        tickets: [
          CrmTicket(
            ticketId: 'TKT-001',
            title: 'API Integration Issue',
            status: 'open',
            priority: 'high',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          CrmTicket(
            ticketId: 'TKT-002',
            title: 'Billing Inquiry',
            status: 'resolved',
            priority: 'medium',
            createdAt: DateTime.now().subtract(const Duration(days: 10)),
          ),
          CrmTicket(
            ticketId: 'TKT-003',
            title: 'Feature Request: Dashboard Export',
            status: 'in_progress',
            priority: 'low',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
        ],
        notes: [
          CrmNote(
            noteId: 'NOTE-001',
            content: 'Customer expressed interest in upgrading to Premium tier. Follow up after Q2.',
            author: 'Sarah Johnson',
            createdAt: DateTime.now().subtract(const Duration(days: 7)),
          ),
          CrmNote(
            noteId: 'NOTE-002',
            content: 'Resolved previous billing discrepancy. Customer satisfied with resolution.',
            author: 'Mike Chen',
            createdAt: DateTime.now().subtract(const Duration(days: 14)),
          ),
        ],
      ),
    );
  }

  CallInfo _createCallInfoWithoutCrm() {
    return CallInfo(
      callId: 'CALL-2024-002',
      phoneNumber: '+1 (555) 987-6543',
      callerName: null, // Unknown caller
      callStartTime: DateTime.now().subtract(const Duration(minutes: 2)),
      direction: CallDirection.inbound,
      status: CallStatus.active,
      agentId: 'AGT-001',
      agentName: 'Sarah Johnson',
      crmData: null, // No CRM data available
    );
  }
}
