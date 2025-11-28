import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';

enum ElegantButtonType {
  primary,
  secondary,
  outline,
  text,
  gradient,
}

enum ElegantButtonSize {
  small,
  medium,
  large,
}

class ElegantButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ElegantButtonType type;
  final ElegantButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Color? customColor;
  final EdgeInsetsGeometry? padding;

  const ElegantButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ElegantButtonType.primary,
    this.size = ElegantButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.customColor,
    this.padding,
  });

  EdgeInsetsGeometry get _buttonPadding {
    if (padding != null) return padding!;
    
    switch (size) {
      case ElegantButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMedium,
          vertical: AppTheme.spacingSmall,
        );
      case ElegantButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLarge,
          vertical: AppTheme.spacingMedium,
        );
      case ElegantButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXLarge,
          vertical: AppTheme.spacingLarge,
        );
    }
  }

  double get _fontSize {
    switch (size) {
      case ElegantButtonSize.small:
        return 14;
      case ElegantButtonSize.medium:
        return 16;
      case ElegantButtonSize.large:
        return 18;
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: _fontSize + 4,
        width: _fontSize + 4,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getTextColor(),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: _fontSize + 2,
            color: _getTextColor(),
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          Text(
            text,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w600,
        color: _getTextColor(),
      ),
    );
  }

  Color _getTextColor() {
    switch (type) {
      case ElegantButtonType.primary:
      case ElegantButtonType.gradient:
        return Colors.white;
      case ElegantButtonType.secondary:
        return Colors.white;
      case ElegantButtonType.outline:
      case ElegantButtonType.text:
        return customColor ?? AppTheme.primaryColor;
    }
  }

  Color _getBackgroundColor() {
    if (onPressed == null) {
      return Colors.grey.shade300;
    }

    switch (type) {
      case ElegantButtonType.primary:
        return customColor ?? AppTheme.primaryColor;
      case ElegantButtonType.secondary:
        return customColor ?? AppTheme.secondaryColor;
      case ElegantButtonType.outline:
      case ElegantButtonType.text:
        return Colors.transparent;
      case ElegantButtonType.gradient:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      width: fullWidth ? double.infinity : null,
      decoration: type == ElegantButtonType.gradient
          ? BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius:
                  BorderRadius.circular(AppTheme.borderRadiusMedium),
              boxShadow: onPressed != null
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            )
          : BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius:
                  BorderRadius.circular(AppTheme.borderRadiusMedium),
              border: type == ElegantButtonType.outline
                  ? Border.all(
                      color: customColor ?? AppTheme.primaryColor,
                      width: 1.5,
                    )
                  : null,
              boxShadow: type == ElegantButtonType.primary ||
                      type == ElegantButtonType.secondary
                  ? [
                      BoxShadow(
                        color: _getBackgroundColor().withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          child: Container(
            padding: _buttonPadding,
            child: Center(
              child: _buildButtonContent(),
            ),
          ),
        ),
      ),
    );

    return button;
  }
}
