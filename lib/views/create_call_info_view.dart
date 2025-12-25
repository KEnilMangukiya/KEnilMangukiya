import 'package:flutter/material.dart';
import '../models/crm_field.dart';
import '../theme/app_theme.dart';

class CreateCallInfoView extends StatefulWidget {
  const CreateCallInfoView({Key? key}) : super(key: key);

  @override
  State<CreateCallInfoView> createState() => _CreateCallInfoViewState();
}

class _CreateCallInfoViewState extends State<CreateCallInfoView> {
  // Simulator for CRM availability
  bool _isCrmAvailable = true;
  
  // Form Keys
  final _simpleFormKey = GlobalKey<FormState>();
  final _dynamicFormKey = GlobalKey<FormState>();

  // Simple Form Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  // Dynamic Form Data Store
  final Map<String, dynamic> _dynamicFormData = {};

  // Mock Dynamic Fields configuration
  final List<CRMField> _crmFields = [
    CRMField(id: 'ticket_id', label: 'Ticket ID', type: CRMFieldType.text, isRequired: true),
    CRMField(id: 'priority', label: 'Priority', type: CRMFieldType.dropdown, options: ['Low', 'Medium', 'High', 'Critical'], isRequired: true),
    CRMField(id: 'contract_value', label: 'Contract Value', type: CRMFieldType.number),
    CRMField(id: 'follow_up_date', label: 'Follow-up Date', type: CRMFieldType.date),
    CRMField(id: 'is_vip', label: 'VIP Customer', type: CRMFieldType.checkbox),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'New Call Info',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          // Toggle for demo purposes
          Switch(
            value: _isCrmAvailable,
            onChanged: (val) {
              setState(() {
                _isCrmAvailable = val;
              });
            },
            activeColor: AppTheme.primaryColor,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 32),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ));
                },
                child: _isCrmAvailable ? _buildDynamicCRMForm() : _buildSimpleForm(),
              ),
              SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isCrmAvailable ? 'CRM Integration Active' : 'Manual Entry Mode',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: _isCrmAvailable ? AppTheme.primaryColor : AppTheme.secondaryColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          _isCrmAvailable 
              ? 'Fill in the details below. Fields are dynamically synced with your CRM configuration.' 
              : 'CRM is currently unavailable. Please enter the customer details manually.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSimpleForm() {
    return Container(
      key: ValueKey('simple_form'),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _simpleFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Customer Details'),
            SizedBox(height: 24),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (v) => v?.isEmpty == true ? 'Name is required' : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v?.isEmpty == true ? 'Phone is required' : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24),
            _buildSectionTitle('Call Notes'),
            SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter call summary and key takeaways...',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicCRMForm() {
    return Container(
      key: ValueKey('dynamic_form'),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Form(
        key: _dynamicFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cloud_sync_outlined, color: AppTheme.primaryColor),
                SizedBox(width: 12),
                _buildSectionTitle('Dynamic CRM Fields'),
              ],
            ),
            SizedBox(height: 24),
            ..._crmFields.map((field) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildDynamicField(field),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicField(CRMField field) {
    switch (field.type) {
      case CRMFieldType.text:
      case CRMFieldType.number:
        return TextFormField(
          decoration: InputDecoration(
            labelText: field.label,
            suffixIcon: field.isRequired 
              ? Icon(Icons.star_rate_rounded, size: 8, color: Colors.red) 
              : null,
          ),
          keyboardType: field.type == CRMFieldType.number 
              ? TextInputType.number 
              : TextInputType.text,
          validator: field.isRequired 
              ? (v) => v?.isEmpty == true ? '${field.label} is required' : null 
              : null,
          onSaved: (val) => _dynamicFormData[field.id] = val,
        );
      
      case CRMFieldType.dropdown:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: field.label,
          ),
          items: field.options?.map((opt) => DropdownMenuItem(
            value: opt,
            child: Text(opt),
          )).toList(),
          onChanged: (val) {
            setState(() {
              _dynamicFormData[field.id] = val;
            });
          },
          validator: field.isRequired 
              ? (v) => v == null ? 'Please select ${field.label}' : null 
              : null,
        );

      case CRMFieldType.date:
        return InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                _dynamicFormData[field.id] = date.toIso8601String().split('T')[0];
              });
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: field.label,
              suffixIcon: Icon(Icons.calendar_today_outlined),
            ),
            child: Text(
              _dynamicFormData[field.id] ?? 'Select Date',
              style: TextStyle(
                color: _dynamicFormData[field.id] == null 
                    ? AppTheme.subTextColor 
                    : AppTheme.textColor,
              ),
            ),
          ),
        );

      case CRMFieldType.checkbox:
        return CheckboxListTile(
          title: Text(field.label),
          value: _dynamicFormData[field.id] ?? false,
          activeColor: AppTheme.primaryColor,
          contentPadding: EdgeInsets.zero,
          onChanged: (val) {
            setState(() {
              _dynamicFormData[field.id] = val;
            });
          },
        );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.subTextColor),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textColor,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: AppTheme.subTextColor.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textColor),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _saveCallInfo,
            child: Text('Save Call Info'),
          ),
        ),
      ],
    );
  }

  void _saveCallInfo() {
    if (_isCrmAvailable) {
      if (_dynamicFormKey.currentState?.validate() == true) {
        _dynamicFormKey.currentState?.save();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saving to CRM: $_dynamicFormData')),
        );
      }
    } else {
      if (_simpleFormKey.currentState?.validate() == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saving local record for: ${_nameController.text}')),
        );
      }
    }
  }
}
