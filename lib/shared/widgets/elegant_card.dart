import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';

enum ElegantCardType {
  elevated,
  outlined,
  filled,
  gradient,
}

class ElegantCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final ElegantCardType type;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Gradient? gradient;
  final double borderRadius;
  final bool showShadow;
  final double elevation;

  const ElegantCard({
    super.key,
    required this.child,
    this.onTap,
    this.type = ElegantCardType.elevated,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.gradient,
    this.borderRadius = AppTheme.borderRadiusMedium,
    this.showShadow = true,
    this.elevation = 2,
  });

  BoxDecoration _getDecoration() {
    switch (type) {
      case ElegantCardType.elevated:
        return BoxDecoration(
          color: color ?? AppTheme.cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : null,
        );
      
      case ElegantCardType.outlined:
        return BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        );
      
      case ElegantCardType.filled:
        return BoxDecoration(
          color: color ?? AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(borderRadius),
        );
      
      case ElegantCardType.gradient:
        return BoxDecoration(
          gradient: gradient ?? AppTheme.cardGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: _getDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ??
                const EdgeInsets.all(AppTheme.spacingMedium),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Widget especializado para tarjetas de contenido
class ContentCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;

  const ContentCard({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.content,
    this.onTap,
    this.padding,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElegantCard(
      onTap: onTap,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || subtitle != null || leading != null || trailing != null)
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppTheme.spacingMedium),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: context.textTheme.titleLarge,
                        ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppTheme.spacingXSmall),
                        Text(
                          subtitle!,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          if (showDivider && content != null) ...[
            const SizedBox(height: AppTheme.spacingMedium),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: AppTheme.spacingMedium),
          ] else if (content != null && (title != null || subtitle != null))
            const SizedBox(height: AppTheme.spacingMedium),
          if (content != null) content!,
        ],
      ),
    );
  }
}
