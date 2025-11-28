import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/core/config/app_config.dart';

/// Widget para mostrar imágenes de red con fallback
/// Maneja automáticamente URLs relativas del backend
class NetworkImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const NetworkImageWithFallback({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildErrorWidget();
    }

    final fullUrl = AppConfig.getImageUrl(imageUrl);
    
    // LOG TEMPORAL para debug
    print('🖼️ NetworkImageWithFallback - Original URL: $imageUrl');
    print('🖼️ NetworkImageWithFallback - Full URL: $fullUrl');

    Widget imageWidget = Image.network(
      fullUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        
        return placeholder ??
            Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildErrorWidget();
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: 48,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

/// Widget para avatar de usuario con imagen de red
class NetworkAvatarImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final String fallbackInitials;

  const NetworkAvatarImage({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.fallbackInitials = 'U',
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppTheme.primaryColor,
        child: Text(
          fallbackInitials,
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final fullUrl = AppConfig.getImageUrl(imageUrl);

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: NetworkImage(fullUrl),
      onBackgroundImageError: (exception, stackTrace) {
        // Error handled by showing fallback
      },
      child: null,
    );
  }
}
