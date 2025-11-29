import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/users/data/remote/user_service.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';
import 'package:artcollab_mobile/shared/widgets/user_avatar.dart';
import 'package:artcollab_mobile/shared/widgets/network_image_with_fallback.dart';

class UserProfilePage extends StatefulWidget {
  final int userId;

  const UserProfilePage({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserService _userService = UserService();

  UserProfileDto? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _userService.getUserById(widget.userId);

      if (result is Success<UserProfileDto> && result.data != null) {
        setState(() {
          _profile = result.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = (result as Error).message ?? 'Error al cargar perfil';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error inesperado: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : _buildProfileContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Error al cargar perfil',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              _errorMessage ?? 'Ocurrió un error inesperado',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            ElegantButton(
              text: 'Reintentar',
              icon: Icons.refresh,
              type: ElegantButtonType.primary,
              onPressed: _loadProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_profile == null) return const SizedBox();

    return CustomScrollView(
      slivers: [
        // App Bar con foto de portada
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: AppTheme.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                NetworkImageWithFallback(
                  // Si _profile!.foto es nulo, usa 'assets/fallback_image.png' (o una URL de reserva).
                  imageUrl: _profile!.foto ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Contenido
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -50),
            child: Column(
              children: [
                // Avatar grande
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: UserAvatar(
                    photoUrl: _profile!.foto,
                    initials: _profile!.initials,
                    radius: 60,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingMedium),

                // Nombre
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium),
                  child: Text(
                    _profile!.fullName,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingSmall),

                // Rol
                if (_profile!.roleName != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                      vertical: AppTheme.spacingXSmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusLarge),
                      border: Border.all(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    child: Text(
                      _profile!.roleName!,
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: AppTheme.spacingLarge),

                // Información de contacto
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    children: [
                      if (_profile!.descripcion != null &&
                          _profile!.descripcion!.isNotEmpty) ...[
                        ElegantCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: AppTheme.primaryColor,
                                  ),
                                  const SizedBox(width: AppTheme.spacingSmall),
                                  Text(
                                    'Sobre mí',
                                    style:
                                        context.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spacingSmall),
                              Text(
                                _profile!.descripcion!,
                                style: context.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                      ],

                      // Información de contacto
                      ElegantCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.contact_mail,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: AppTheme.spacingSmall),
                                Text(
                                  'Información de Contacto',
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),
                            _buildInfoRow(
                                Icons.email, 'Email', _profile!.email),
                            if (_profile!.telefono != null) ...[
                              const Divider(height: AppTheme.spacingMedium),
                              _buildInfoRow(
                                  Icons.phone, 'Teléfono', _profile!.telefono!),
                            ],
                            if (_profile!.ubicacion != null) ...[
                              const Divider(height: AppTheme.spacingMedium),
                              _buildInfoRow(Icons.location_on, 'Ubicación',
                                  _profile!.ubicacion!),
                            ],
                            if (_profile!.username != null) ...[
                              const Divider(height: AppTheme.spacingMedium),
                              _buildInfoRow(Icons.alternate_email, 'Usuario',
                                  '@${_profile!.username!}'),
                            ],
                          ],
                        ),
                      ),

                      // Redes sociales
                      if (_profile!.redesSociales != null &&
                          _profile!.redesSociales!.isNotEmpty) ...[
                        const SizedBox(height: AppTheme.spacingMedium),
                        ElegantCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: AppTheme.primaryColor,
                                  ),
                                  const SizedBox(width: AppTheme.spacingSmall),
                                  Text(
                                    'Redes Sociales',
                                    style:
                                        context.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spacingMedium),
                              ..._profile!.redesSociales!.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppTheme.spacingSmall),
                                  child: _buildInfoRow(
                                    _getSocialIcon(entry.key),
                                    _formatSocialName(entry.key),
                                    entry.value,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: AppTheme.spacingXLarge),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getSocialIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'twitter':
      case 'x':
        return Icons.tag;
      case 'facebook':
        return Icons.facebook;
      case 'linkedin':
        return Icons.work;
      case 'github':
        return Icons.code;
      case 'behance':
      case 'dribbble':
      case 'artstation':
        return Icons.palette;
      default:
        return Icons.link;
    }
  }

  String _formatSocialName(String platform) {
    return platform[0].toUpperCase() + platform.substring(1);
  }
}
