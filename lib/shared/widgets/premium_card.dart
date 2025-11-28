import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';

/// Premium card widget with advanced styling and animations
class PremiumCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool isPremium;
  final bool hasGlow;
  final bool isElevated;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  
  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.isPremium = false,
    this.hasGlow = false,
    this.isElevated = false,
    this.backgroundColor,
    this.gradient,
    this.width,
    this.height,
    this.borderRadius,
  });
  
  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: PremiumTheme.animationFast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: PremiumTheme.curveDefault,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  
  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }
  
  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }
  
  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }
  
  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
  }
  
  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? 
        BorderRadius.circular(PremiumTheme.radiusLarge);
    
    List<BoxShadow> shadows = [];
    
    if (widget.isPremium) {
      shadows = PremiumTheme.premiumShadow;
    } else if (widget.isElevated || _isHovered) {
      shadows = PremiumTheme.elevatedShadow;
    } else {
      shadows = PremiumTheme.cardShadow;
    }
    
    if (widget.hasGlow && widget.isPremium) {
      shadows = [
        ...shadows,
        BoxShadow(
          color: PremiumTheme.premiumGold.withOpacity(0.3),
          blurRadius: 30,
          offset: const Offset(0, 0),
        ),
      ];
    }
    
    Widget cardContent = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding ?? const EdgeInsets.all(PremiumTheme.spacingM),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? PremiumTheme.cardBackground,
        gradient: widget.gradient,
        borderRadius: borderRadius,
        boxShadow: shadows,
        border: widget.isPremium ? Border.all(
          color: PremiumTheme.premiumGold.withOpacity(0.3),
          width: 1,
        ) : null,
      ),
      child: widget.child,
    );
    
    if (widget.isPremium) {
      cardContent = Stack(
        children: [
          cardContent,
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                gradient: PremiumTheme.premiumGradient,
                borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
              ),
              child: const Text(
                'PREMIUM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    if (widget.onTap != null) {
      return MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: cardContent,
              );
            },
          ),
        ),
      );
    }
    
    return cardContent;
  }
}

/// Specialized card for displaying statistics
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final String? trend;
  final bool isPositiveTrend;
  final VoidCallback? onTap;
  
  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.color,
    this.trend,
    this.isPositiveTrend = true,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? PremiumTheme.illustratorPrimary;
    
    return PremiumCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: effectiveColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                ),
                child: Icon(
                  icon,
                  color: effectiveColor,
                  size: 20,
                ),
              ),
              const Spacer(),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (isPositiveTrend ? Colors.green : Colors.red)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: isPositiveTrend ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: PremiumTheme.labelSmall.copyWith(
                          color: isPositiveTrend ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: PremiumTheme.spacingM),
          Text(
            value,
            style: PremiumTheme.displayMedium.copyWith(
              color: PremiumTheme.textPrimary,
            ),
          ),
          const SizedBox(height: PremiumTheme.spacingXS),
          Text(
            title,
            style: PremiumTheme.bodyMedium.copyWith(
              color: PremiumTheme.textSecondary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: PremiumTheme.spacingXS),
            Text(
              subtitle!,
              style: PremiumTheme.bodySmall.copyWith(
                color: PremiumTheme.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Card for displaying recommendations with match scores
class RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double matchScore;
  final String? imageUrl;
  final List<String> tags;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool isSaved;
  
  const RecommendationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.matchScore,
    this.imageUrl,
    this.tags = const [],
    this.onTap,
    this.onSave,
    this.isSaved = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final matchColor = matchScore >= 90 
        ? Colors.green 
        : matchScore >= 70 
            ? Colors.orange 
            : Colors.red;
    
    return PremiumCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: matchColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${matchScore.toInt()}% Match',
                      style: PremiumTheme.labelMedium.copyWith(
                        color: matchColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (matchScore >= 90) ...[
                      const SizedBox(width: 4),
                      const Text('🔥', style: TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              if (onSave != null)
                IconButton(
                  onPressed: onSave,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? PremiumTheme.illustratorPrimary : PremiumTheme.textSecondary,
                  ),
                  iconSize: 20,
                ),
            ],
          ),
          const SizedBox(height: PremiumTheme.spacingM),
          
          if (imageUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
              child: Image.network(
                imageUrl!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: PremiumTheme.backgroundLight,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: PremiumTheme.textTertiary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: PremiumTheme.spacingM),
          ],
          
          Text(
            title,
            style: PremiumTheme.titleMedium.copyWith(
              color: PremiumTheme.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: PremiumTheme.spacingXS),
          Text(
            subtitle,
            style: PremiumTheme.bodyMedium.copyWith(
              color: PremiumTheme.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          if (tags.isNotEmpty) ...[
            const SizedBox(height: PremiumTheme.spacingM),
            Wrap(
              spacing: PremiumTheme.spacingXS,
              runSpacing: PremiumTheme.spacingXS,
              children: tags.take(3).map((tag) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: PremiumTheme.illustratorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                ),
                child: Text(
                  tag,
                  style: PremiumTheme.labelSmall.copyWith(
                    color: PremiumTheme.illustratorPrimary,
                  ),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
