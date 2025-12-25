import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/customer_form_model.dart';
import '../theme/app_theme.dart';
import 'glassmorphic_card.dart';

/// Customer detail form widget for when CRM is not available
/// Allows agents to manually add customer information
class CustomerDetailForm extends StatefulWidget {
  final CustomerFormData? initialData;
  final Function(CustomerFormData) onSave;
  final VoidCallback? onCancel;
  final bool isLoading;

  const CustomerDetailForm({
    super.key,
    this.initialData,
    required this.onSave,
    this.onCancel,
    this.isLoading = false,
  });

  @override
  State<CustomerDetailForm> createState() => _CustomerDetailFormState();
}

class _CustomerDetailFormState extends State<CustomerDetailForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late CustomerFormData _formData;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _designationController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _notesController = TextEditingController();

  int _currentStep = 0;
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formData = widget.initialData ?? CustomerFormData();
    _initializeControllers();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  void _initializeControllers() {
    _firstNameController.text = _formData.firstName;
    _lastNameController.text = _formData.lastName;
    _emailController.text = _formData.email;
    _phoneController.text = _formData.phone;
    _alternatePhoneController.text = _formData.alternatePhone ?? '';
    _companyController.text = _formData.company ?? '';
    _designationController.text = _formData.designation ?? '';
    _addressController.text = _formData.address ?? '';
    _cityController.text = _formData.city ?? '';
    _stateController.text = _formData.state ?? '';
    _zipCodeController.text = _formData.zipCode ?? '';
    _countryController.text = _formData.country ?? '';
    _notesController.text = _formData.notes ?? '';
    _tags.addAll(_formData.tags);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _companyController.dispose();
    _designationController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(),
          const SizedBox(height: AppTheme.spacingMD),
          _buildProgressIndicator(),
          const SizedBox(height: AppTheme.spacingLG),
          Form(
            key: _formKey,
            child: _buildFormContent(),
          ),
          const SizedBox(height: AppTheme.spacingLG),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingSM),
          decoration: BoxDecoration(
            gradient: AppTheme.warmGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: const Icon(
            Icons.person_add_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: AppTheme.spacingSM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Customer',
              style: AppTheme.headingSmall.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Add customer details manually',
              style: AppTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    final steps = ['Basic Info', 'Contact', 'Company', 'Notes'];
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentStep = index),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: isCompleted || isCurrent
                          ? AppTheme.primaryGradient
                          : null,
                      color: !isCompleted && !isCurrent
                          ? AppTheme.surfaceLight
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : Text(
                              '${index + 1}',
                              style: AppTheme.labelSmall.copyWith(
                                color: isCurrent
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[index],
                          style: AppTheme.labelSmall.copyWith(
                            color: isCurrent
                                ? AppTheme.primaryColor
                                : AppTheme.textSecondary,
                            fontWeight:
                                isCurrent ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (index < steps.length - 1)
                    Container(
                      height: 2,
                      width: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppTheme.primaryColor
                            : AppTheme.surfaceMedium,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFormContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: [
        _buildBasicInfoStep(),
        _buildContactStep(),
        _buildCompanyStep(),
        _buildNotesStep(),
      ][_currentStep],
    );
  }

  Widget _buildBasicInfoStep() {
    return GradientBorderCard(
      key: const ValueKey('basic'),
      gradient: AppTheme.primaryGradient,
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.person_outline, 'Personal Information'),
          const SizedBox(height: AppTheme.spacingMD),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  icon: Icons.badge_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  icon: Icons.badge_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMD),
          _buildCategorySelector(),
          const SizedBox(height: AppTheme.spacingMD),
          _buildPrioritySelector(),
        ],
      ),
    );
  }

  Widget _buildContactStep() {
    return GradientBorderCard(
      key: const ValueKey('contact'),
      gradient: AppTheme.secondaryGradient,
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.contact_phone_outlined, 'Contact Details'),
          const SizedBox(height: AppTheme.spacingMD),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: _buildTextField(
                  controller: _alternatePhoneController,
                  label: 'Alternate Phone',
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyStep() {
    return GradientBorderCard(
      key: const ValueKey('company'),
      gradient: AppTheme.coolGradient,
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.business_outlined, 'Company Information'),
          const SizedBox(height: AppTheme.spacingMD),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _companyController,
                  label: 'Company Name',
                  icon: Icons.apartment_outlined,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: _buildTextField(
                  controller: _designationController,
                  label: 'Designation',
                  icon: Icons.work_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMD),
          _buildTextField(
            controller: _addressController,
            label: 'Address',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _cityController,
                  label: 'City',
                  icon: Icons.location_city_outlined,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: _buildTextField(
                  controller: _stateController,
                  label: 'State',
                  icon: Icons.map_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _zipCodeController,
                  label: 'ZIP Code',
                  icon: Icons.pin_drop_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: _buildTextField(
                  controller: _countryController,
                  label: 'Country',
                  icon: Icons.public_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesStep() {
    return GradientBorderCard(
      key: const ValueKey('notes'),
      gradient: AppTheme.warmGradient,
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.note_add_outlined, 'Additional Information'),
          const SizedBox(height: AppTheme.spacingMD),
          _buildTagInput(),
          const SizedBox(height: AppTheme.spacingMD),
          _buildTextField(
            controller: _notesController,
            label: 'Notes',
            icon: Icons.notes_outlined,
            maxLines: 4,
            hint: 'Add any additional notes about this customer...',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: AppTheme.spacingSM),
        Text(title, style: AppTheme.headingSmall),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      inputFormatters: inputFormatters,
      style: AppTheme.bodyLarge,
      decoration: AppTheme.inputDecoration(
        label: label,
        hint: hint,
        prefixIcon: icon,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Category', style: AppTheme.labelMedium),
        const SizedBox(height: AppTheme.spacingSM),
        Wrap(
          spacing: AppTheme.spacingSM,
          runSpacing: AppTheme.spacingSM,
          children: CustomerCategory.values.map((category) {
            final isSelected = _formData.category == category;
            return _buildSelectableChip(
              label: category.displayName,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _formData = _formData.copyWith(category: category);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority Level', style: AppTheme.labelMedium),
        const SizedBox(height: AppTheme.spacingSM),
        Row(
          children: CustomerPriority.values.map((priority) {
            final isSelected = _formData.priority == priority;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: priority != CustomerPriority.values.last
                      ? AppTheme.spacingSM
                      : 0,
                ),
                child: _buildPriorityButton(priority, isSelected),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriorityButton(CustomerPriority priority, bool isSelected) {
    final color = _getPriorityColor(priority);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _formData = _formData.copyWith(priority: priority);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spacingSM,
          horizontal: AppTheme.spacingXS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              priority.displayName,
              style: AppTheme.labelSmall.copyWith(
                color: isSelected ? color : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(CustomerPriority priority) {
    switch (priority) {
      case CustomerPriority.low:
        return AppTheme.success;
      case CustomerPriority.medium:
        return AppTheme.info;
      case CustomerPriority.high:
        return AppTheme.warning;
      case CustomerPriority.urgent:
        return AppTheme.error;
    }
  }

  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
          vertical: AppTheme.spacingSM,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: !isSelected ? AppTheme.surfaceLight : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.surfaceMedium,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTagInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: AppTheme.labelMedium),
        const SizedBox(height: AppTheme.spacingSM),
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingSM),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppTheme.spacingSM,
                runSpacing: AppTheme.spacingSM,
                children: [
                  ..._tags.map((tag) => _buildTagChip(tag)),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        hintText: 'Add tag...',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppTheme.spacingXS,
                        ),
                      ),
                      style: AppTheme.bodyMedium,
                      onSubmitted: (value) {
                        if (value.isNotEmpty && !_tags.contains(value)) {
                          setState(() {
                            _tags.add(value);
                            _tagController.clear();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSM,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: AppTheme.labelSmall.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _tags.remove(tag);
              });
            },
            child: Icon(
              Icons.close,
              size: 14,
              color: AppTheme.primaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMD),
              ),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: AppTheme.spacingMD),
        Expanded(
          flex: 2,
          child: _currentStep < 3
              ? ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentStep++;
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingMD,
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: AppTheme.shadowColored,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: widget.isLoading ? null : _handleSave,
                    icon: widget.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_rounded, size: 18),
                    label: Text(widget.isLoading ? 'Saving...' : 'Save Customer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacingMD,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final customerData = CustomerFormData(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        alternatePhone: _alternatePhoneController.text.trim().isNotEmpty
            ? _alternatePhoneController.text.trim()
            : null,
        company: _companyController.text.trim().isNotEmpty
            ? _companyController.text.trim()
            : null,
        designation: _designationController.text.trim().isNotEmpty
            ? _designationController.text.trim()
            : null,
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : null,
        city: _cityController.text.trim().isNotEmpty
            ? _cityController.text.trim()
            : null,
        state: _stateController.text.trim().isNotEmpty
            ? _stateController.text.trim()
            : null,
        zipCode: _zipCodeController.text.trim().isNotEmpty
            ? _zipCodeController.text.trim()
            : null,
        country: _countryController.text.trim().isNotEmpty
            ? _countryController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        category: _formData.category,
        priority: _formData.priority,
        tags: _tags,
      );
      
      widget.onSave(customerData);
    }
  }
}
