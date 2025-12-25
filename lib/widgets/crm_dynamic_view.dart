import 'package:flutter/material.dart';
import '../models/call_info_model.dart';
import '../theme/app_theme.dart';
import 'glassmorphic_card.dart';

/// Dynamic CRM View Widget that displays CRM data when available
class CrmDynamicView extends StatefulWidget {
  final CrmData crmData;
  final VoidCallback? onRefresh;
  final Function(CrmField)? onFieldEdit;

  const CrmDynamicView({
    super.key,
    required this.crmData,
    this.onRefresh,
    this.onFieldEdit,
  });

  @override
  State<CrmDynamicView> createState() => _CrmDynamicViewState();
}

class _CrmDynamicViewState extends State<CrmDynamicView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCrmHeader(),
        const SizedBox(height: AppTheme.spacingMD),
        _buildCustomerCard(),
        const SizedBox(height: AppTheme.spacingMD),
        _buildTabSection(),
        const SizedBox(height: AppTheme.spacingMD),
        _buildTabContent(),
      ],
    );
  }

  Widget _buildCrmHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingSM),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: const Icon(
            Icons.hub_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: AppTheme.spacingSM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connected to ${widget.crmData.crmType.toUpperCase()}',
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'CRM ID: ${widget.crmData.crmId}',
              style: AppTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        if (widget.onRefresh != null)
          IconButton(
            onPressed: widget.onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.surfaceLight,
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
      ],
    );
  }

  Widget _buildCustomerCard() {
    return GlassmorphicCard(
      gradient: AppTheme.primaryGradient,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLG),
        child: Column(
          children: [
            Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: AppTheme.spacingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.crmData.customerName ?? 'Unknown Customer',
                        style: AppTheme.headingSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      if (widget.crmData.designation != null ||
                          widget.crmData.company != null)
                        Text(
                          [
                            widget.crmData.designation,
                            widget.crmData.company,
                          ].whereType<String>().join(' at '),
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),
            const Divider(color: Colors.white24),
            const SizedBox(height: AppTheme.spacingMD),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStat(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: widget.crmData.customerEmail ?? 'N/A',
                ),
                _buildQuickStat(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: widget.crmData.customerPhone ?? 'N/A',
                ),
                _buildQuickStat(
                  icon: Icons.attach_money,
                  label: 'Value',
                  value: widget.crmData.accountValue != null
                      ? '\$${widget.crmData.accountValue!.toStringAsFixed(0)}'
                      : 'N/A',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final name = widget.crmData.customerName ?? 'U';
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
    
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: AppTheme.headingMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = widget.crmData.accountStatus ?? 'active';
    final color = _getStatusColor(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSM,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingXS),
          Text(
            status.toUpperCase(),
            style: AppTheme.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.success;
      case 'inactive':
        return AppTheme.textTertiary;
      case 'pending':
        return AppTheme.warning;
      case 'churned':
        return AppTheme.error;
      default:
        return AppTheme.info;
    }
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 18),
        const SizedBox(height: AppTheme.spacingXS),
        Text(
          label,
          style: AppTheme.labelSmall.copyWith(
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTheme.labelMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTabSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: AppTheme.shadowSmall,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.labelMedium,
        tabs: [
          _buildTab(Icons.info_outline, 'Details', 0),
          _buildTab(Icons.confirmation_number_outlined, 'Tickets', 1),
          _buildTab(Icons.note_alt_outlined, 'Notes', 2),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: [
        _buildDetailsTab(),
        _buildTicketsTab(),
        _buildNotesTab(),
      ][_selectedTabIndex],
    );
  }

  Widget _buildDetailsTab() {
    return Container(
      key: const ValueKey('details'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Column(
        children: [
          ...widget.crmData.customFields.map((field) => _buildFieldRow(field)),
          if (widget.crmData.lastInteraction != null)
            _buildInfoRow(
              Icons.schedule,
              'Last Interaction',
              _formatDate(widget.crmData.lastInteraction!),
            ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(CrmField field) {
    return InkWell(
      onTap: field.isEditable && widget.onFieldEdit != null
          ? () => widget.onFieldEdit!(field)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
          vertical: AppTheme.spacingSM,
        ),
        child: Row(
          children: [
            Icon(
              _getFieldIcon(field.type),
              size: 18,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: AppTheme.spacingSM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(field.label, style: AppTheme.labelSmall),
                  const SizedBox(height: 2),
                  Text(
                    field.value.isNotEmpty ? field.value : 'Not set',
                    style: AppTheme.bodyMedium.copyWith(
                      color: field.value.isNotEmpty
                          ? AppTheme.textPrimary
                          : AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (field.isEditable)
              Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppTheme.textTertiary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMD,
        vertical: AppTheme.spacingSM,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textSecondary),
          const SizedBox(width: AppTheme.spacingSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.labelSmall),
                const SizedBox(height: 2),
                Text(value, style: AppTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFieldIcon(CrmFieldType type) {
    switch (type) {
      case CrmFieldType.text:
        return Icons.text_fields;
      case CrmFieldType.number:
        return Icons.numbers;
      case CrmFieldType.email:
        return Icons.email_outlined;
      case CrmFieldType.phone:
        return Icons.phone_outlined;
      case CrmFieldType.date:
        return Icons.calendar_today_outlined;
      case CrmFieldType.currency:
        return Icons.attach_money;
      case CrmFieldType.dropdown:
        return Icons.arrow_drop_down_circle_outlined;
      case CrmFieldType.boolean:
        return Icons.toggle_on_outlined;
    }
  }

  Widget _buildTicketsTab() {
    final tickets = widget.crmData.tickets ?? [];
    
    if (tickets.isEmpty) {
      return _buildEmptyState(
        key: const ValueKey('tickets'),
        icon: Icons.confirmation_number_outlined,
        title: 'No Tickets',
        subtitle: 'No support tickets found for this customer',
      );
    }

    return Container(
      key: const ValueKey('tickets'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        itemCount: tickets.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) => _buildTicketItem(tickets[index]),
      ),
    );
  }

  Widget _buildTicketItem(CrmTicket ticket) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSM),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getPriorityColor(ticket.priority).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              Icons.confirmation_number,
              color: _getPriorityColor(ticket.priority),
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.title,
                  style: AppTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '#${ticket.ticketId} • ${_formatDate(ticket.createdAt)}',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
          _buildTicketStatusChip(ticket.status),
        ],
      ),
    );
  }

  Widget _buildTicketStatusChip(String status) {
    final color = _getTicketStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSM,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTheme.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return AppTheme.error;
      case 'medium':
        return AppTheme.warning;
      case 'low':
        return AppTheme.success;
      default:
        return AppTheme.info;
    }
  }

  Color _getTicketStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppTheme.info;
      case 'in_progress':
      case 'inprogress':
        return AppTheme.warning;
      case 'resolved':
      case 'closed':
        return AppTheme.success;
      case 'pending':
        return AppTheme.accentOrange;
      default:
        return AppTheme.textSecondary;
    }
  }

  Widget _buildNotesTab() {
    final notes = widget.crmData.notes ?? [];
    
    if (notes.isEmpty) {
      return _buildEmptyState(
        key: const ValueKey('notes'),
        icon: Icons.note_alt_outlined,
        title: 'No Notes',
        subtitle: 'No notes have been added for this customer',
      );
    }

    return Container(
      key: const ValueKey('notes'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        itemCount: notes.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) => _buildNoteItem(notes[index]),
      ),
    );
  }

  Widget _buildNoteItem(CrmNote note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    note.author.isNotEmpty ? note.author[0].toUpperCase() : 'A',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.accentPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note.author, style: AppTheme.labelMedium),
                    Text(
                      _formatDateTime(note.createdAt),
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSM),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Text(
              note.content,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required Key key,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: AppTheme.textTertiary),
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Text(title, style: AppTheme.headingSmall),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            subtitle,
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
