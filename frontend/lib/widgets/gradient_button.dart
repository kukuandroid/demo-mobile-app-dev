import 'package:flutter/material.dart';

/// A modern gradient button widget with clean design and smooth animations
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final List<Color> gradientColors;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height = 56,
    this.gradientColors = const [
      Color(0xFF667eea),
      Color(0xFF764ba2),
    ],
    this.borderRadius,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.onPressed != null ? _onTapDown : null,
            onTapUp: widget.onPressed != null ? _onTapUp : null,
            onTapCancel: widget.onPressed != null ? _onTapCancel : null,
            onTap: widget.onPressed,
            child: Container(
              width: widget.width,
              height: widget.height,
              padding: widget.padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.onPressed != null
                      ? widget.gradientColors
                      : widget.gradientColors
                          .map((color) => color.withOpacity(0.6))
                          .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors.first.withOpacity(0.3),
                    offset: const Offset(0, 8),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: _isPressed
                        ? Colors.black.withOpacity(0.1)
                        : Colors.white.withOpacity(0.1),
                    offset: _isPressed
                        ? const Offset(0, 2)
                        : const Offset(0, 1),
                    blurRadius: _isPressed ? 4 : 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: widget.textStyle ??
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
