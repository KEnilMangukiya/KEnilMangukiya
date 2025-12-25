import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern, Material 3 "Create Call Info" view that supports:
/// - CRM calls: show dynamic fields based on a server-driven schema.
/// - Non-CRM calls: show a simple customer detail form.
///
/// Plug it in by passing [crm] when the call is linked to CRM; otherwise pass null.
class CreateCallInfoView extends StatefulWidget {
  const CreateCallInfoView({
    super.key,
    required this.onSubmit,
    this.crm,
    this.initial,
  });

  /// If null -> non-CRM flow (simple customer detail form).
  /// If non-null -> CRM flow (dynamic fields).
  final CrmContext? crm;

  /// Optional initial values to edit an existing draft.
  final CallInfoDraft? initial;

  /// Called when user taps "Save call info".
  final Future<void> Function(CallInfoDraft draft) onSubmit;

  @override
  State<CreateCallInfoView> createState() => _CreateCallInfoViewState();
}

class _CreateCallInfoViewState extends State<CreateCallInfoView> {
  final _formKey = GlobalKey<FormState>();

  // Common fields
  late final TextEditingController _summaryCtrl;
  late final TextEditingController _notesCtrl;

  // Non-CRM customer fields
  late final TextEditingController _customerNameCtrl;
  late final TextEditingController _customerPhoneCtrl;
  late final TextEditingController _customerEmailCtrl;
  late final TextEditingController _customerCompanyCtrl;
  late final TextEditingController _customerAddressCtrl;

  // CRM dynamic field values
  late Map<String, dynamic> _crmValues;

  bool _saving = false;
  DateTime? _callDate;
  CallOutcome _outcome = CallOutcome.connected;

  bool get _isCrm => widget.crm != null;

  void _setCrmValue(String key, dynamic value, {bool notify = true}) {
    _crmValues[key] = value;
    if (notify && mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _summaryCtrl = TextEditingController(text: initial?.summary ?? '');
    _notesCtrl = TextEditingController(text: initial?.notes ?? '');

    _customerNameCtrl = TextEditingController(text: initial?.customerName ?? '');
    _customerPhoneCtrl =
        TextEditingController(text: initial?.customerPhone ?? '');
    _customerEmailCtrl =
        TextEditingController(text: initial?.customerEmail ?? '');
    _customerCompanyCtrl =
        TextEditingController(text: initial?.customerCompany ?? '');
    _customerAddressCtrl =
        TextEditingController(text: initial?.customerAddress ?? '');

    _callDate = initial?.callDate ?? DateTime.now();
    _outcome = initial?.outcome ?? CallOutcome.connected;
    _crmValues = Map<String, dynamic>.from(initial?.crmValues ?? const {});
  }

  @override
  void dispose() {
    _summaryCtrl.dispose();
    _notesCtrl.dispose();
    _customerNameCtrl.dispose();
    _customerPhoneCtrl.dispose();
    _customerEmailCtrl.dispose();
    _customerCompanyCtrl.dispose();
    _customerAddressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCallDate() async {
    final now = DateTime.now();
    final initial = _callDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    if (!mounted) return;
    setState(() => _callDate = picked);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    // CRM required checks for non-Text widgets (checkboxes, dates) are done here.
    if (_isCrm) {
      final crm = widget.crm!;
      for (final f in crm.fields) {
        if (!f.required) continue;
        final v = _crmValues[f.key];
        final isEmpty = v == null ||
            (v is String && v.trim().isEmpty) ||
            (v is List && v.isEmpty) ||
            (v is bool && v == false);
        if (isEmpty) {
          _showSnack('Please fill required field: ${f.label}');
          return;
        }
      }
    }

    setState(() => _saving = true);
    try {
      final draft = CallInfoDraft(
        callDate: _callDate,
        outcome: _outcome,
        summary: _summaryCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
        customerName: _isCrm ? null : _customerNameCtrl.text.trim(),
        customerPhone: _isCrm ? null : _customerPhoneCtrl.text.trim(),
        customerEmail: _isCrm ? null : _customerEmailCtrl.text.trim(),
        customerCompany: _isCrm ? null : _customerCompanyCtrl.text.trim(),
        customerAddress: _isCrm ? null : _customerAddressCtrl.text.trim(),
        crmId: widget.crm?.crmId,
        crmModule: widget.crm?.module,
        crmValues: _isCrm ? _crmValues : null,
      );
      await widget.onSubmit(draft);
      if (!mounted) return;
      _showSnack('Saved');
      Navigator.of(context).maybePop();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crm = widget.crm;
    final title = _isCrm ? 'Create CRM call info' : 'Create call info';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              title: title,
              subtitle: _isCrm
                  ? '${crm!.module} • ${crm.displayName}'
                  : 'Manual customer details',
              badgeText: _isCrm ? 'CRM' : 'Manual',
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: _CallMetaCard(
                          callDate: _callDate,
                          outcome: _outcome,
                          onPickDate: _pickCallDate,
                          onOutcomeChanged: (v) =>
                              setState(() => _outcome = v),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: _SectionCard(
                          title: 'Call summary',
                          subtitle:
                              'Keep it short; you can add detailed notes below.',
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _summaryCtrl,
                                textInputAction: TextInputAction.next,
                                decoration: _inputDecoration(
                                  context,
                                  label: 'Summary',
                                  hint: 'e.g. Follow up on pricing and timeline',
                                  icon: Icons.subject_rounded,
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Summary is required';
                                  }
                                  if (v.trim().length < 6) {
                                    return 'Please add a bit more detail';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _notesCtrl,
                                minLines: 4,
                                maxLines: 10,
                                decoration: _inputDecoration(
                                  context,
                                  label: 'Notes (optional)',
                                  hint:
                                      'Key points, objections, next steps, reminders…',
                                  icon: Icons.sticky_note_2_rounded,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: _isCrm
                            ? _CrmDynamicFormCard(
                                context: crm!,
                                values: _crmValues,
                                onChanged: _setCrmValue,
                              )
                            : _ManualCustomerFormCard(
                                customerNameCtrl: _customerNameCtrl,
                                customerPhoneCtrl: _customerPhoneCtrl,
                                customerEmailCtrl: _customerEmailCtrl,
                                customerCompanyCtrl: _customerCompanyCtrl,
                                customerAddressCtrl: _customerAddressCtrl,
                              ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),
            _BottomBar(
              saving: _saving,
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(
  BuildContext context, {
  required String label,
  String? hint,
  IconData? icon,
}) {
  final theme = Theme.of(context);
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: icon == null ? null : Icon(icon),
    filled: true,
    fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.55),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.badgeText,
  });

  final String title;
  final String subtitle;
  final String badgeText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primaryContainer,
            cs.secondaryContainer,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.call_rounded, color: cs.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onPrimaryContainer.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _Pill(
            text: badgeText,
            background: cs.onPrimaryContainer.withOpacity(0.12),
            foreground: cs.onPrimaryContainer,
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.background,
    required this.foreground,
  });

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.saving,
    required this.onSubmit,
  });

  final bool saving;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, -6),
            color: theme.colorScheme.shadow.withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: saving ? null : onSubmit,
                icon: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(saving ? 'Saving…' : 'Save call info'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    this.subtitle,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _CallMetaCard extends StatelessWidget {
  const _CallMetaCard({
    required this.callDate,
    required this.outcome,
    required this.onPickDate,
    required this.onOutcomeChanged,
  });

  final DateTime? callDate;
  final CallOutcome outcome;
  final VoidCallback onPickDate;
  final ValueChanged<CallOutcome> onOutcomeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateText = callDate == null
        ? 'Select date'
        : '${callDate!.year.toString().padLeft(4, '0')}-'
            '${callDate!.month.toString().padLeft(2, '0')}-'
            '${callDate!.day.toString().padLeft(2, '0')}';

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Call details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onPickDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withOpacity(0.55),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_rounded),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              dateText,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: CallOutcome.values.map((o) {
                final selected = o == outcome;
                final label = o.label;
                return ChoiceChip(
                  selected: selected,
                  label: Text(label),
                  onSelected: (_) => onOutcomeChanged(o),
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? theme.colorScheme.onSecondaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  selectedColor: theme.colorScheme.secondaryContainer,
                  backgroundColor:
                      theme.colorScheme.surfaceContainerHighest.withOpacity(0.55),
                  side: BorderSide(
                    color: selected
                        ? Colors.transparent
                        : theme.colorScheme.outlineVariant.withOpacity(0.6),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualCustomerFormCard extends StatelessWidget {
  const _ManualCustomerFormCard({
    required this.customerNameCtrl,
    required this.customerPhoneCtrl,
    required this.customerEmailCtrl,
    required this.customerCompanyCtrl,
    required this.customerAddressCtrl,
  });

  final TextEditingController customerNameCtrl;
  final TextEditingController customerPhoneCtrl;
  final TextEditingController customerEmailCtrl;
  final TextEditingController customerCompanyCtrl;
  final TextEditingController customerAddressCtrl;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Customer details',
      subtitle: 'Not linked to CRM — add customer info manually.',
      child: Column(
        children: [
          TextFormField(
            controller: customerNameCtrl,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              context,
              label: 'Customer name',
              hint: 'e.g. John Patel',
              icon: Icons.person_rounded,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Name is required';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: customerPhoneCtrl,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDecoration(
              context,
              label: 'Phone',
              hint: 'e.g. 9876543210',
              icon: Icons.phone_rounded,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Phone is required';
              if (v.trim().length < 7) return 'Enter a valid phone';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: customerEmailCtrl,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(
              context,
              label: 'Email (optional)',
              hint: 'e.g. john@company.com',
              icon: Icons.alternate_email_rounded,
            ),
            validator: (v) {
              final s = (v ?? '').trim();
              if (s.isEmpty) return null;
              final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
              return ok ? null : 'Enter a valid email';
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: customerCompanyCtrl,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              context,
              label: 'Company (optional)',
              hint: 'e.g. Acme Pvt Ltd',
              icon: Icons.apartment_rounded,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: customerAddressCtrl,
            minLines: 2,
            maxLines: 4,
            decoration: _inputDecoration(
              context,
              label: 'Address (optional)',
              hint: 'Street, city, state…',
              icon: Icons.location_on_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

typedef CrmValueChanged = void Function(String key, dynamic value, {bool notify});

class _CrmDynamicFormCard extends StatefulWidget {
  const _CrmDynamicFormCard({
    required this.context,
    required this.values,
    required this.onChanged,
  });

  final CrmContext context;
  final Map<String, dynamic> values;
  final CrmValueChanged onChanged;

  @override
  State<_CrmDynamicFormCard> createState() => _CrmDynamicFormCardState();
}

class _CrmDynamicFormCardState extends State<_CrmDynamicFormCard> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  TextEditingController _controllerFor(String key) {
    return _controllers.putIfAbsent(key, () {
      final initial = widget.values[key];
      return TextEditingController(text: (initial ?? '').toString());
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    final theme = Theme.of(buildContext);
    return _SectionCard(
      title: 'CRM fields',
      subtitle: 'Server-driven fields for this module.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CrmRecordBanner(
            module: widget.context.module,
            recordName: widget.context.displayName,
            recordId: widget.context.crmId,
          ),
          const SizedBox(height: 12),
          ...widget.context.fields.map((f) {
            final v = widget.values[f.key];
            final label = f.required ? '${f.label} *' : f.label;
            final commonDecoration = _inputDecoration(
              buildContext,
              label: label,
              hint: f.hint,
              icon: f.icon,
            );

            Widget fieldWidget;
            switch (f.type) {
              case CrmFieldType.text:
                fieldWidget = TextFormField(
                  controller: _controllerFor(f.key),
                  textInputAction: TextInputAction.next,
                  decoration: commonDecoration,
                  onChanged: (s) => widget.onChanged(f.key, s, notify: false),
                  validator: (s) {
                    final value = (s ?? '').trim();
                    if (f.required && value.isEmpty) return 'Required';
                    if (f.maxLength != null && value.length > f.maxLength!) {
                      return 'Max ${f.maxLength} chars';
                    }
                    return null;
                  },
                );
                break;
              case CrmFieldType.multiline:
                fieldWidget = TextFormField(
                  controller: _controllerFor(f.key),
                  minLines: 3,
                  maxLines: 8,
                  decoration: commonDecoration,
                  onChanged: (s) => widget.onChanged(f.key, s, notify: false),
                  validator: (s) {
                    final value = (s ?? '').trim();
                    if (f.required && value.isEmpty) return 'Required';
                    return null;
                  },
                );
                break;
              case CrmFieldType.number:
              case CrmFieldType.currency:
                fieldWidget = TextFormField(
                  controller: _controllerFor(f.key),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: commonDecoration.copyWith(
                    prefixText: f.type == CrmFieldType.currency
                        ? '${f.currency ?? ''} '
                        : null,
                  ),
                  onChanged: (s) => widget.onChanged(f.key, s, notify: false),
                  validator: (s) {
                    final value = (s ?? '').trim();
                    if (f.required && value.isEmpty) return 'Required';
                    if (value.isEmpty) return null;
                    final numOk = num.tryParse(value) != null;
                    return numOk ? null : 'Invalid number';
                  },
                );
                break;
              case CrmFieldType.email:
                fieldWidget = TextFormField(
                  controller: _controllerFor(f.key),
                  keyboardType: TextInputType.emailAddress,
                  decoration: commonDecoration,
                  onChanged: (s) => widget.onChanged(f.key, s, notify: false),
                  validator: (s) {
                    final value = (s ?? '').trim();
                    if (f.required && value.isEmpty) return 'Required';
                    if (value.isEmpty) return null;
                    final ok =
                        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
                    return ok ? null : 'Invalid email';
                  },
                );
                break;
              case CrmFieldType.phone:
                fieldWidget = TextFormField(
                  controller: _controllerFor(f.key),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: commonDecoration,
                  onChanged: (s) => widget.onChanged(f.key, s, notify: false),
                  validator: (s) {
                    final value = (s ?? '').trim();
                    if (f.required && value.isEmpty) return 'Required';
                    if (value.isEmpty) return null;
                    return value.length >= 7 ? null : 'Invalid phone';
                  },
                );
                break;
              case CrmFieldType.dropdown:
                fieldWidget = DropdownButtonFormField<String>(
                  value: (v is String && v.isNotEmpty) ? v : null,
                  decoration: commonDecoration,
                  items: (f.options ?? const [])
                      .map(
                        (opt) => DropdownMenuItem(
                          value: opt.value,
                          child: Text(opt.label),
                        ),
                      )
                      .toList(),
                  onChanged: (s) => widget.onChanged(f.key, s),
                  validator: (s) {
                    if (f.required && (s == null || s.isEmpty)) return 'Required';
                    return null;
                  },
                );
                break;
              case CrmFieldType.checkbox:
                final checked = (v is bool) ? v : false;
                fieldWidget = _CheckboxField(
                  title: label,
                  subtitle: f.hint,
                  value: checked,
                  onChanged: (b) => widget.onChanged(f.key, b),
                );
                break;
              case CrmFieldType.date:
                final date = v is DateTime ? v : null;
                fieldWidget = _DateField(
                  label: label,
                  hint: f.hint,
                  value: date,
                  onChanged: (d) => widget.onChanged(f.key, d),
                );
                break;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: fieldWidget,
            );
          }),
          Text(
            'Tip: these fields are dynamic — you can render whatever your CRM API returns.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CrmRecordBanner extends StatelessWidget {
  const _CrmRecordBanner({
    required this.module,
    required this.recordName,
    required this.recordId,
  });

  final String module;
  final String recordName;
  final String recordId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.primary.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cs.onPrimaryContainer.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.hub_rounded, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  recordName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onPrimaryContainer.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _Pill(
            text: '#${recordId.length > 6 ? recordId.substring(0, 6) : recordId}',
            background: cs.onPrimaryContainer.withOpacity(0.12),
            foreground: cs.onPrimaryContainer,
          ),
        ],
      ),
    );
  }
}

class _CheckboxField extends StatelessWidget {
  const _CheckboxField({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
  });

  final String label;
  final String? hint;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = value == null
        ? (hint ?? 'Select date')
        : '${value!.year.toString().padLeft(4, '0')}-'
            '${value!.month.toString().padLeft(2, '0')}-'
            '${value!.day.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 10),
          lastDate: DateTime(now.year + 10),
        );
        onChanged(picked);
      },
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.55),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.event_rounded),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: value == null
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Represents "CRM context" for a call (if the call is linked to CRM).
class CrmContext {
  const CrmContext({
    required this.crmId,
    required this.module,
    required this.displayName,
    required this.fields,
  });

  final String crmId;
  final String module; // e.g. "Lead", "Deal", "Contact"
  final String displayName; // e.g. "Acme - Renewal"
  final List<CrmFieldDefinition> fields; // schema to render dynamically
}

/// Server-driven field definition.
class CrmFieldDefinition {
  const CrmFieldDefinition({
    required this.key,
    required this.label,
    required this.type,
    this.required = false,
    this.hint,
    this.icon,
    this.maxLength,
    this.options,
    this.currency,
  });

  final String key; // unique key for value map
  final String label;
  final CrmFieldType type;
  final bool required;
  final String? hint;
  final IconData? icon;
  final int? maxLength;
  final List<CrmOption>? options;
  final String? currency; // for currency fields
}

class CrmOption {
  const CrmOption({required this.value, required this.label});
  final String value;
  final String label;
}

enum CrmFieldType { text, multiline, number, currency, email, phone, dropdown, checkbox, date }

enum CallOutcome {
  connected,
  notAnswered,
  busy,
  wrongNumber,
  followUp,
}

extension CallOutcomeLabel on CallOutcome {
  String get label {
    switch (this) {
      case CallOutcome.connected:
        return 'Connected';
      case CallOutcome.notAnswered:
        return 'No answer';
      case CallOutcome.busy:
        return 'Busy';
      case CallOutcome.wrongNumber:
        return 'Wrong #';
      case CallOutcome.followUp:
        return 'Follow-up';
    }
  }
}

/// Payload you can send to API.
class CallInfoDraft {
  const CallInfoDraft({
    required this.callDate,
    required this.outcome,
    required this.summary,
    required this.notes,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.customerCompany,
    this.customerAddress,
    this.crmId,
    this.crmModule,
    this.crmValues,
  });

  final DateTime? callDate;
  final CallOutcome outcome;
  final String summary;
  final String notes;

  // Non-CRM customer details
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? customerCompany;
  final String? customerAddress;

  // CRM linkage and dynamic values
  final String? crmId;
  final String? crmModule;
  final Map<String, dynamic>? crmValues;

  Map<String, dynamic> toJson() {
    return {
      'callDate': callDate?.toIso8601String(),
      'outcome': outcome.name,
      'summary': summary,
      'notes': notes,
      'customer': crmId == null
          ? {
              'name': customerName,
              'phone': customerPhone,
              'email': customerEmail,
              'company': customerCompany,
              'address': customerAddress,
            }
          : null,
      'crm': crmId == null
          ? null
          : {
              'id': crmId,
              'module': crmModule,
              'values': _serializeCrmValues(crmValues ?? const {}),
            },
    };
  }

  static Map<String, dynamic> _serializeCrmValues(Map<String, dynamic> src) {
    final out = <String, dynamic>{};
    for (final e in src.entries) {
      final v = e.value;
      if (v is DateTime) {
        out[e.key] = v.toIso8601String();
      } else {
        out[e.key] = v;
      }
    }
    return out;
  }
}

/// Optional helper to quickly see the dynamic CRM UI in action.
CrmContext demoCrmContext() {
  return const CrmContext(
    crmId: 'LEAD-10492',
    module: 'Lead',
    displayName: 'Acme Foods — Website inquiry',
    fields: [
      CrmFieldDefinition(
        key: 'next_step',
        label: 'Next step',
        type: CrmFieldType.dropdown,
        required: true,
        hint: 'Choose the next action',
        icon: Icons.route_rounded,
        options: [
          CrmOption(value: 'demo', label: 'Schedule demo'),
          CrmOption(value: 'quote', label: 'Send quote'),
          CrmOption(value: 'follow_up', label: 'Follow up later'),
        ],
      ),
      CrmFieldDefinition(
        key: 'budget',
        label: 'Budget',
        type: CrmFieldType.currency,
        currency: '₹',
        hint: 'Approximate budget',
        icon: Icons.payments_rounded,
      ),
      CrmFieldDefinition(
        key: 'decision_maker',
        label: 'Decision maker name',
        type: CrmFieldType.text,
        hint: 'Who approves?',
        icon: Icons.verified_user_rounded,
        maxLength: 60,
      ),
      CrmFieldDefinition(
        key: 'email',
        label: 'Work email',
        type: CrmFieldType.email,
        required: true,
        hint: 'Primary email',
        icon: Icons.alternate_email_rounded,
      ),
      CrmFieldDefinition(
        key: 'call_back_on',
        label: 'Call back on',
        type: CrmFieldType.date,
        hint: 'Pick a date',
        icon: Icons.event_available_rounded,
      ),
      CrmFieldDefinition(
        key: 'high_priority',
        label: 'High priority',
        type: CrmFieldType.checkbox,
        hint: 'Mark as urgent if needed',
        icon: Icons.priority_high_rounded,
      ),
      CrmFieldDefinition(
        key: 'crm_notes',
        label: 'CRM notes',
        type: CrmFieldType.multiline,
        hint: 'Notes saved into CRM record',
        icon: Icons.note_alt_rounded,
      ),
    ],
  );
}

