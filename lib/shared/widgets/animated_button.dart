import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';

/// Premium animated button with advanced styling and interactions
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isPremium;
  final AnimatedButtonStyle style;
  final AnimatedButtonSize size;
  final double? width;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  
  const AnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isPremium = false,
    this.style = AnimatedButtonStyle.primary,
    this.size = AnimatedButtonSize.medium,
    this.width,
    this.gradient,
    this.backgroundColor,
    this.textColor,
  });
  
  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  
  bool _isPressed = false;
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: PremiumTheme.animationFast,
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: PremiumTheme.curveDefault,
    ));
    
    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.linear,
    ));
    
    if (widget.isPremium) {
      _shimmerController.repeat();
    }
  }
  
  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }
  
  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _scaleController.forward();
    }
  }
  
  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }
  
  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }
  
  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
  }
  
  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    
    double height;
    EdgeInsets padding;
    TextStyle textStyle;
    
    switch (widget.size) {
      case AnimatedButtonSize.small:
        height = 36;
        padding = const EdgeInsets.symmetric(
          horizontal: PremiumTheme.spacingM,
          vertical: PremiumTheme.spacingS,
        );
        textStyle = PremiumTheme.labelMedium;
        break;
      case AnimatedButtonSize.medium:
        height = 48;
        padding = const EdgeInsets.symmetric(
          horizontal: PremiumTheme.spacingL,
          vertical: PremiumTheme.spacingM,
        );
        textStyle = PremiumTheme.labelLarge;
        break;
      case AnimatedButtonSize.large:
        height = 56;
        padding = const EdgeInsets.symmetric(
          horizontal: PremiumTheme.spacingXL,
          vertical: PremiumTheme.spacingM,
        );
        textStyle = PremiumTheme.titleMedium;
        break;
    }
    
    Color backgroundColor;
    Color textColor;
    LinearGradient? gradient;
    
    if (widget.gradient != null) {
      gradient = widget.gradient;
      textColor = widget.textColor ?? Colors.white;
    } else if (widget.isPremium) {
      gradient = PremiumTheme.premiumGradient;
      textColor = Colors.white;
    } else {
      switch (widget.style) {
        case AnimatedButtonStyle.primary:
          backgroundColor = widget.backgroundColor ?? PremiumTheme.illustratorPrimary;
          textColor = widget.textColor ?? Colors.white;
          break;
        case AnimatedButtonStyle.secondary:
          backgroundColor = widget.backgroundColor ?? PremiumTheme.cardBackground;
          textColor = widget.textColor ?? PremiumTheme.illustratorPrimary;
          break;
        case AnimatedButtonStyle.outline:
          backgroundColor = Colors.transparent;
          textColor = widget.textColor ?? PremiumTheme.illustratorPrimary;
          break;
        case AnimatedButtonStyle.ghost:
          backgroundColor = Colors.transparent;
          textColor = widget.textColor ?? PremiumTheme.textPrimary;
          break;
      }
    }
    
    if (!isEnabled) {
      backgroundColor = PremiumTheme.textTertiary;
      textColor = Colors.white;
      gradient = null;
    }
    
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: PremiumTheme.spacingS),
        ] else if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: textColor,
            size: 18,
          ),
          const SizedBox(width: PremiumTheme.spacingS),
        ],
        Text(
          widget.isLoading ? 'Loading...' : widget.text,
          style: textStyle.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
    
    Widget button = Container(
      width: widget.width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? widget.backgroundColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(PremiumTheme.radiusMedium),
        border: widget.style == AnimatedButtonStyle.outline
            ? Border.all(
                color: isEnabled ? PremiumTheme.illustratorPrimary : PremiumTheme.textTertiary,
                width: 1.5,
              )
            : null,
        boxShadow: widget.style == AnimatedButtonStyle.primary && isEnabled
            ? [
                BoxShadow(
                  color: (widget.backgroundColor ?? PremiumTheme.illustratorPrimary)
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: buttonContent,
    );
    
    if (widget.isPremium && isEnabled) {
      button = AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: const [
                  Colors.transparent,
                  Colors.white24,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(_shimmerAnimation.value - 1, 0),
                end: Alignment(_shimmerAnimation.value, 0),
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: child,
          );
        },
        child: button,
      );
    }
    
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: isEnabled ? widget.onPressed : null,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: PremiumTheme.animationFast,
                curve: PremiumTheme.curveDefault,
                transform: Matrix4.identity()
                  ..translate(0.0, _isHovered && isEnabled ? -2.0 : 0.0),
                child: button,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Button styles
enum AnimatedButtonStyle {
  primary,
  secondary,
  outline,
  ghost,
}

/// Button sizes
enum AnimatedButtonSize {
  small,
  medium,
  large,
}
