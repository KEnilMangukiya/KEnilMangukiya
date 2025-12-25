enum CRMFieldType { text, number, date, dropdown, checkbox }

class CRMField {
  final String id;
  final String label;
  final CRMFieldType type;
  final bool isRequired;
  final List<String>? options; // For dropdowns

  CRMField({
    required this.id,
    required this.label,
    required this.type,
    this.isRequired = false,
    this.options,
  });
}
