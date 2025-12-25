import 'package:flutter/material.dart';
import '../models/call_info_model.dart';
import '../models/customer_form_model.dart';
import '../theme/app_theme.dart';
import '../widgets/crm_dynamic_view.dart';
import '../widgets/customer_detail_form.dart';
import '../widgets/glassmorphic_card.dart';

/// Main Call Info Screen
/// Displays call information with dynamic CRM data or manual customer form
class CallInfoScreen extends StatefulWidget {
  final CallInfo callInfo;
  final Function(CustomerFormData)? onCustomerSave;
  final VoidCallback? onCrmRefresh;
  final VoidCallback? onEndCall;
  final VoidCallback? onHoldCall;
  final VoidCallback? onTransferCall;

  const CallInfoScreen({
    super.key,
    required this.callInfo,
    this.onCustomerSave,
    this.onCrmRefresh,
    this.onEndCall,
    this.onHoldCall,
    this.onTransferCall,
  });

  @override
  State<CallInfoScreen> createState() => _CallInfoScreenState();
}

class _CallInfoScreenState extends State<CallInfoScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  
  bool _isCallTimerRunning = true;
  Duration _callDuration = Duration.zero;
  bool _isSavingCustomer = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startCallTimer();
  }

  void _initAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerSlideAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _contentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentAnimationController.forward();
    });
  }

  void _startCallTimer() {
    _callDuration = widget.callInfo.duration ?? Duration.zero;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_isCallTimerRunning) return false;
      setState(() {
        _callDuration += const Duration(seconds: 1);
      });
      return true;
    });
  }

  @override
  void dispose() {
    _isCallTimerRunning = false;
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _buildAnimatedHeader(),
            Expanded(
              child: FadeTransition(
                opacity: _contentFadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacingMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuickActions(),
                      const SizedBox(height: AppTheme.spacingLG),
                      _buildContentSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _headerSlideAnimation.value),
          child: Opacity(
            opacity: _headerAnimationController.value,
            child: _buildHeader(),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppTheme.radiusXLarge),
          bottomRight: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          children: [
            _buildHeaderTop(),
            const SizedBox(height: AppTheme.spacingLG),
            _buildCallerInfo(),
            const SizedBox(height: AppTheme.spacingMD),
            _buildCallStatus(),
            const SizedBox(height: AppTheme.spacingMD),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.15),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMD,
            vertical: AppTheme.spacingSM,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          ),
          child: Row(
            children: [
              _buildPulsingDot(),
              const SizedBox(width: AppTheme.spacingSM),
              Text(
                _formatDuration(_callDuration),
                style: AppTheme.headingSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.15),
          ),
        ),
      ],
    );
  }

  Widget _buildPulsingDot() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(value),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _getStatusColor().withOpacity(0.5),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
      onEnd: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Color _getStatusColor() {
    switch (widget.callInfo.status) {
      case CallStatus.active:
        return AppTheme.success;
      case CallStatus.onHold:
        return AppTheme.warning;
      case CallStatus.completed:
        return AppTheme.textTertiary;
      case CallStatus.missed:
        return AppTheme.error;
      case CallStatus.transferred:
        return AppTheme.info;
    }
  }

  Widget _buildCallerInfo() {
    final callerName = widget.callInfo.callerName ?? 'Unknown Caller';
    final initials = callerName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Row(
      children: [
        _buildCallerAvatar(initials),
        const SizedBox(width: AppTheme.spacingMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                callerName,
                style: AppTheme.headingMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    widget.callInfo.direction == CallDirection.inbound
                        ? Icons.call_received_rounded
                        : Icons.call_made_rounded,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.callInfo.phoneNumber,
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildCrmBadge(),
      ],
    );
  }

  Widget _buildCallerAvatar(String initials) {
    return Stack(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              initials,
              style: AppTheme.headingLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              _getStatusIcon(),
              size: 10,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon() {
    switch (widget.callInfo.status) {
      case CallStatus.active:
        return Icons.call_rounded;
      case CallStatus.onHold:
        return Icons.pause_rounded;
      case CallStatus.completed:
        return Icons.check_rounded;
      case CallStatus.missed:
        return Icons.call_missed_rounded;
      case CallStatus.transferred:
        return Icons.swap_horiz_rounded;
    }
  }

  Widget _buildCrmBadge() {
    final hasCrm = widget.callInfo.hasCrmData;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSM,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: hasCrm
            ? AppTheme.success.withOpacity(0.2)
            : AppTheme.warning.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: hasCrm
              ? AppTheme.success.withOpacity(0.5)
              : AppTheme.warning.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasCrm ? Icons.hub_outlined : Icons.person_add_outlined,
            size: 14,
            color: hasCrm ? AppTheme.success : AppTheme.warning,
          ),
          const SizedBox(width: 4),
          Text(
            hasCrm ? 'CRM' : 'New',
            style: AppTheme.labelSmall.copyWith(
              color: hasCrm ? AppTheme.success : AppTheme.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallStatus() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingSM),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusItem(
            Icons.access_time_rounded,
            'Started',
            _formatTime(widget.callInfo.callStartTime),
          ),
          _buildVerticalDivider(),
          _buildStatusItem(
            Icons.person_outline,
            'Agent',
            widget.callInfo.agentName ?? 'Unassigned',
          ),
          _buildVerticalDivider(),
          _buildStatusItem(
            _getDirectionIcon(),
            'Type',
            widget.callInfo.direction == CallDirection.inbound
                ? 'Inbound'
                : 'Outbound',
          ),
        ],
      ),
    );
  }

  IconData _getDirectionIcon() {
    return widget.callInfo.direction == CallDirection.inbound
        ? Icons.call_received_rounded
        : Icons.call_made_rounded;
  }

  Widget _buildStatusItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.white.withOpacity(0.7)),
        const SizedBox(height: 4),
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
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.shadowMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.call_end_rounded,
            label: 'End Call',
            color: AppTheme.error,
            onTap: widget.onEndCall,
          ),
          _buildActionButton(
            icon: widget.callInfo.status == CallStatus.onHold
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
            label: widget.callInfo.status == CallStatus.onHold
                ? 'Resume'
                : 'Hold',
            color: AppTheme.warning,
            onTap: widget.onHoldCall,
          ),
          _buildActionButton(
            icon: Icons.swap_horiz_rounded,
            label: 'Transfer',
            color: AppTheme.info,
            onTap: widget.onTransferCall,
          ),
          _buildActionButton(
            icon: Icons.dialpad_rounded,
            label: 'Keypad',
            color: AppTheme.accentPurple,
            onTap: () => _showKeypad(context),
          ),
          _buildActionButton(
            icon: Icons.volume_up_rounded,
            label: 'Speaker',
            color: AppTheme.secondaryColor,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            label,
            style: AppTheme.labelSmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    if (widget.callInfo.hasCrmData) {
      return CrmDynamicView(
        crmData: widget.callInfo.crmData!,
        onRefresh: widget.onCrmRefresh,
        onFieldEdit: (field) {
          // Handle field edit
        },
      );
    } else {
      return CustomerDetailForm(
        onSave: (data) {
          setState(() {
            _isSavingCustomer = true;
          });
          widget.onCustomerSave?.call(data);
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _isSavingCustomer = false;
              });
              _showSuccessSnackbar('Customer saved successfully!');
            }
          });
        },
        isLoading: _isSavingCustomer,
      );
    }
  }

  void _showKeypad(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildKeypadSheet(),
    );
  }

  Widget _buildKeypadSheet() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXLarge),
          topRight: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.surfaceMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLG),
          Text('Keypad', style: AppTheme.headingSmall),
          const SizedBox(height: AppTheme.spacingLG),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: AppTheme.spacingSM,
            crossAxisSpacing: AppTheme.spacingSM,
            childAspectRatio: 1.5,
            children: [
              '1', '2', '3',
              '4', '5', '6',
              '7', '8', '9',
              '*', '0', '#',
            ].map((key) => _buildKeypadKey(key)).toList(),
          ),
          const SizedBox(height: AppTheme.spacingLG),
        ],
      ),
    );
  }

  Widget _buildKeypadKey(String key) {
    return GestureDetector(
      onTap: () {
        // Handle DTMF tone
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Center(
          child: Text(
            key,
            style: AppTheme.headingMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: AppTheme.spacingSM),
            Text(message),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        margin: const EdgeInsets.all(AppTheme.spacingMD),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
