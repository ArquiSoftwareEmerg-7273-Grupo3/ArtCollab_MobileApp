import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/config/app_config.dart';

/// Widget reutilizable para mostrar avatares de usuario con fallback automático
class UserAvatar extends StatefulWidget {
  final String? photoUrl;
  final String initials;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const UserAvatar({
    super.key,
    this.photoUrl,
    required this.initials,
    this.radius = 20,
    this.backgroundColor = Colors.teal,
    this.textColor = Colors.white,
  });

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  bool _imageLoadError = false;

  @override
  void didUpdateWidget(UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset error state if URL changes
    if (oldWidget.photoUrl != widget.photoUrl) {
      _imageLoadError = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay URL o hubo error, mostrar iniciales
    if (widget.photoUrl == null || 
        widget.photoUrl!.isEmpty || 
        _imageLoadError) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: widget.backgroundColor,
        child: Text(
          widget.initials,
          style: TextStyle(
            fontSize: widget.radius * 0.7,
            color: widget.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // Construir URL completa
    final fullUrl = AppConfig.getImageUrl(widget.photoUrl!);
    
    // LOG TEMPORAL para debug
    print('👤 UserAvatar - Original URL: ${widget.photoUrl}');
    print('👤 UserAvatar - Full URL: $fullUrl');

    // Intentar cargar la imagen
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      backgroundImage: NetworkImage(fullUrl),
      onBackgroundImageError: (exception, stackTrace) {
        // Marcar error para mostrar iniciales
        if (mounted) {
          setState(() {
            _imageLoadError = true;
          });
        }
      },
      child: _imageLoadError
          ? Text(
              widget.initials,
              style: TextStyle(
                fontSize: widget.radius * 0.7,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
