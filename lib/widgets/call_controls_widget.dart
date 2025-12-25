import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Floating call controls widget for quick actions
class CallControlsWidget extends StatefulWidget {
  final VoidCallback? onEndCall;
  final VoidCallback? onMute;
  final VoidCallback? onHold;
  final VoidCallback? onSpeaker;
  final bool isMuted;
  final bool isOnHold;
  final bool isSpeakerOn;

  const CallControlsWidget({
    super.key,
    this.onEndCall,
    this.onMute,
    this.onHold,
    this.onSpeaker,
    this.isMuted = false,
    this.isOnHold = false,
    this.isSpeakerOn = false,
  });

  @override
  State<CallControlsWidget> createState() => _CallControlsWidgetState();
}

class _CallControlsWidgetState extends State<CallControlsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingMD),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 1 - _scaleAnimation.value,
                  child: Opacity(
                    opacity: 1 - _scaleAnimation.value,
                    child: _buildExpandedControls(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingSM),
          _buildMainButton(),
        ],
      ),
    );
  }

  Widget _buildExpandedControls() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.shadowLarge,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(
            icon: widget.isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            label: widget.isMuted ? 'Unmute' : 'Mute',
            color: widget.isMuted ? AppTheme.error : AppTheme.textSecondary,
            isActive: widget.isMuted,
            onTap: widget.onMute,
          ),
          const SizedBox(height: AppTheme.spacingSM),
          _buildControlButton(
            icon: widget.isOnHold
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
            label: widget.isOnHold ? 'Resume' : 'Hold',
            color: widget.isOnHold ? AppTheme.warning : AppTheme.textSecondary,
            isActive: widget.isOnHold,
            onTap: widget.onHold,
          ),
          const SizedBox(height: AppTheme.spacingSM),
          _buildControlButton(
            icon: widget.isSpeakerOn
                ? Icons.volume_up_rounded
                : Icons.volume_down_rounded,
            label: 'Speaker',
            color:
                widget.isSpeakerOn ? AppTheme.info : AppTheme.textSecondary,
            isActive: widget.isSpeakerOn,
            onTap: widget.onSpeaker,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : AppTheme.surfaceLight,
          shape: BoxShape.circle,
          border: isActive
              ? Border.all(color: color.withOpacity(0.5), width: 2)
              : null,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildMainButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // End call button
        GestureDetector(
          onTap: widget.onEndCall,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.error.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.call_end_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingSM),
        // Toggle expand button
        GestureDetector(
          onTap: _toggleExpand,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppTheme.shadowMedium,
            ),
            child: AnimatedRotation(
              turns: _isExpanded ? 0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: AppTheme.textSecondary,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Minimized call indicator that can be shown when navigating away
class MinimizedCallIndicator extends StatelessWidget {
  final String callerName;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback? onEndCall;

  const MinimizedCallIndicator({
    super.key,
    required this.callerName,
    required this.duration,
    this.onTap,
    this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(AppTheme.spacingMD),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
          vertical: AppTheme.spacingSM,
        ),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          boxShadow: AppTheme.shadowColored,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPulsingIcon(),
            const SizedBox(width: AppTheme.spacingSM),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  callerName,
                  style: AppTheme.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatDuration(duration),
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppTheme.spacingMD),
            GestureDetector(
              onTap: onEndCall,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.call_end_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulsingIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2 * value),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.call_rounded,
            color: Colors.white,
            size: 20,
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
