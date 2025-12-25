import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A glassmorphic card with blur effect and gradient background
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final double opacity;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.gradient,
    this.borderRadius = AppTheme.radiusLarge,
    this.blur = 10,
    this.padding,
    this.opacity = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null
                ? Colors.white.withOpacity(opacity)
                : null,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: padding != null
              ? Padding(padding: padding!, child: child)
              : child,
        ),
      ),
    );
  }
}

/// Animated glassmorphic card with hover/tap effects
class AnimatedGlassmorphicCard extends StatefulWidget {
  final Widget child;
  final Gradient? gradient;
  final double borderRadius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const AnimatedGlassmorphicCard({
    super.key,
    required this.child,
    this.gradient,
    this.borderRadius = AppTheme.radiusLarge,
    this.onTap,
    this.padding,
  });

  @override
  State<AnimatedGlassmorphicCard> createState() =>
      _AnimatedGlassmorphicCardState();
}

class _AnimatedGlassmorphicCardState extends State<AnimatedGlassmorphicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20 + _elevationAnimation.value * 2,
                    offset: Offset(0, 10 + _elevationAnimation.value),
                  ),
                ],
              ),
              child: GlassmorphicCard(
                gradient: widget.gradient,
                borderRadius: widget.borderRadius,
                padding: widget.padding,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Neumorphic card with soft shadows
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool isPressed;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.borderRadius = AppTheme.radiusLarge,
    this.padding,
    this.backgroundColor,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppTheme.backgroundPrimary;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  blurRadius: 4,
                  offset: const Offset(-2, -2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(5, 5),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  blurRadius: 15,
                  offset: const Offset(-5, -5),
                ),
              ],
      ),
      child: child,
    );
  }
}

/// Gradient border card
class GradientBorderCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double borderWidth;
  final double borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const GradientBorderCard({
    super.key,
    required this.child,
    this.gradient = AppTheme.primaryGradient,
    this.borderWidth = 2,
    this.borderRadius = AppTheme.radiusLarge,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppTheme.shadowMedium,
      ),
      padding: EdgeInsets.all(borderWidth),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
