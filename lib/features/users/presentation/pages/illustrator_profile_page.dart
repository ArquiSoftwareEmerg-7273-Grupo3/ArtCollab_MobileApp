import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/users/data/remote/user_service.dart';
import 'package:artcollab_mobile/features/portfolio/data/remote/portfolio_service.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';
import 'package:artcollab_mobile/shared/widgets/network_image_with_fallback.dart';
import 'package:artcollab_mobile/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:artcollab_mobile/features/chat/data/remote/chat_service.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';

class IllustratorProfilePage extends StatefulWidget {
  final int illustratorId;
  final UserProfileDto? initialProfile;

  const IllustratorProfilePage({
    super.key,
    required this.illustratorId,
    this.initialProfile,
  });

  @override
  State<IllustratorProfilePage> createState() => _IllustratorProfilePageState();
}

class _IllustratorProfilePageState extends State<IllustratorProfilePage> {
  final UserService _userService = UserService();
  final PortfolioService _portfolioService = PortfolioService();
  final ChatService _chatService = ChatService();
  
  UserProfileDto? _profile;
  List<PortfolioDto> _portfolios = [];
  bool _isLoading = true;
  bool _isCreatingChat = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _profile = widget.initialProfile;
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Cargar perfil si no se proporcionó
      if (_profile == null) {
        final profileResult = await _userService.getUserById(widget.illustratorId);
        if (profileResult is Success<UserProfileDto> && profileResult.data != null) {
          _profile = profileResult.data!;
        } else {
          throw Exception('No se pudo cargar el perfil del ilustrador');
        }
      }

      // Cargar portafolios del ilustrador
      final portfolioResult = await _portfolioService.getPortfoliosByIlustrador(widget.illustratorId);
      if (portfolioResult is Success<List<PortfolioDto>>) {
        _portfolios = portfolioResult.data ?? [];
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar el perfil: $e';
      });
    }
  }

  Future<void> _startChat() async {
    if (_isCreatingChat) return;
    
    setState(() {
      _isCreatingChat = true;
    });

    try {
      // Obtener ID del usuario actual
      final userStorage = UserStorage();
      final currentUserId = await userStorage.getUserId();
      
      if (currentUserId == null) {
        throw Exception('No se pudo obtener el ID del usuario actual');
      }

      debugPrint('📱 Creando chat entre $currentUserId y ${widget.illustratorId}');
      
      // Crear o obtener chat existente
      final result = await _chatService.createChat(currentUserId, widget.illustratorId);
      
      if (result is Success && mounted) {
        debugPrint('✅ Chat creado/obtenido exitosamente');
        
        // Navegar al chat
        if (result.data != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailPage(
                chat: result.data!,
                otherUserName: _profile?.fullName ?? 'Ilustrador',
                otherUserPhoto: _profile?.foto,
                otherUserInitials: _profile?.initials ?? '?',
              ),
            ),
          );
        }
      } else if (mounted) {
        final errorMessage = result is Error ? (result.message ?? 'Error al crear chat') : 'Error al crear chat';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      debugPrint('💥 Error al crear chat: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingChat = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_profile?.fullName ?? 'Perfil del Ilustrador'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_profile != null)
            IconButton(
              icon: _isCreatingChat 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.message),
              onPressed: _isCreatingChat ? null : _startChat,
              tooltip: 'Iniciar Chat',
            ),
        ],
      ),
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
              onPressed: _loadProfileData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_profile == null) {
      return const Center(
        child: Text('No se pudo cargar el perfil'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del perfil
          _buildProfileHeader(),
          const SizedBox(height: AppTheme.spacingLarge),
          
          // Información personal
          _buildPersonalInfo(),
          const SizedBox(height: AppTheme.spacingLarge),
          
          // Redes sociales
          if (_profile!.redesSociales != null && _profile!.redesSociales!.isNotEmpty)
            _buildSocialMediaSection(),
          if (_profile!.redesSociales != null && _profile!.redesSociales!.isNotEmpty)
            const SizedBox(height: AppTheme.spacingLarge),
          
          // Portafolios
          _buildPortfoliosSection(),
          const SizedBox(height: AppTheme.spacingLarge),
          
          // Botón de contacto
          _buildContactButton(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return ElegantCard(
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 60,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: _profile!.foto != null && _profile!.foto!.isNotEmpty
                ? ClipOval(
                    child: NetworkImageWithFallback(
                      imageUrl: _profile!.foto!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          
          // Nombre
          Text(
            _profile!.fullName,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          
          // Rol
          if (_profile!.roleName != null || _profile!.role != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMedium,
                vertical: AppTheme.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                (_profile!.roleName ?? _profile!.role ?? 'ILUSTRADOR').toUpperCase(),
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return ElegantCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Personal',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          
          // Email
          _buildInfoRow(
            Icons.email,
            'Email',
            _profile!.email,
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          
          // Teléfono
          if (_profile!.telefono != null && _profile!.telefono!.isNotEmpty)
            _buildInfoRow(
              Icons.phone,
              'Teléfono',
              _profile!.telefono!,
            ),
          if (_profile!.telefono != null && _profile!.telefono!.isNotEmpty)
            const SizedBox(height: AppTheme.spacingMedium),
          
          // Ubicación
          if (_profile!.ubicacion != null && _profile!.ubicacion!.isNotEmpty)
            _buildInfoRow(
              Icons.location_on,
              'Ubicación',
              _profile!.ubicacion!,
            ),
          if (_profile!.ubicacion != null && _profile!.ubicacion!.isNotEmpty)
            const SizedBox(height: AppTheme.spacingMedium),
          
          // Fecha de nacimiento (si está disponible)
          if (_profile!.fechaNacimiento != null && _profile!.fechaNacimiento!.isNotEmpty)
            _buildInfoRow(
              Icons.calendar_today,
              'Fecha de nacimiento',
              _profile!.fechaNacimiento!,
            ),
          if (_profile!.fechaNacimiento != null && _profile!.fechaNacimiento!.isNotEmpty)
            const SizedBox(height: AppTheme.spacingMedium),
          
          // Descripción
          if (_profile!.descripcion != null && _profile!.descripcion!.isNotEmpty)
            _buildInfoRow(
              Icons.info_outline,
              'Sobre mí',
              _profile!.descripcion!,
            ),
        ],
      ),
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
              const SizedBox(height: AppTheme.spacingXSmall),
              Text(
                value,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortfoliosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Portafolios (${_portfolios.length})',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        
        if (_portfolios.isEmpty)
          ElegantCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    Text(
                      'Sin portafolios disponibles',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      'Este ilustrador aún no ha subido portafolios',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppTheme.spacingMedium,
              mainAxisSpacing: AppTheme.spacingMedium,
              childAspectRatio: 0.8,
            ),
            itemCount: _portfolios.length,
            itemBuilder: (context, index) {
              final portfolio = _portfolios[index];
              return _buildPortfolioCard(portfolio);
            },
          ),
      ],
    );
  }

  Widget _buildPortfolioCard(PortfolioDto portfolio) {
    return ElegantCard(
      onTap: () {
        // TODO: Navegar al detalle del portafolio
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vista de detalle del portafolio próximamente'),
            backgroundColor: AppTheme.infoColor,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del portafolio
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.borderRadiusSmall),
                ),
              ),
              child: portfolio.urlImagen.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.borderRadiusSmall),
                      ),
                      child: NetworkImageWithFallback(
                        imageUrl: portfolio.urlImagen,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
            ),
          ),
          
          // Información del portafolio
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    portfolio.titulo,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spacingXSmall),
                  Text(
                    portfolio.descripcion,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton() {
    return SizedBox(
      width: double.infinity,
      child: ElegantButton(
        text: _isCreatingChat ? 'Iniciando Chat...' : 'Iniciar Conversación',
        icon: _isCreatingChat ? null : Icons.message,
        type: ElegantButtonType.gradient,
        size: ElegantButtonSize.large,
        onPressed: _isCreatingChat ? null : _startChat,
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return ElegantCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Redes Sociales',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Wrap(
            spacing: AppTheme.spacingSmall,
            runSpacing: AppTheme.spacingSmall,
            children: _profile!.redesSociales!.entries.map((entry) {
              IconData icon;
              Color color;
              
              switch (entry.key.toLowerCase()) {
                case 'instagram':
                  icon = Icons.camera_alt;
                  color = Colors.purple;
                  break;
                case 'twitter':
                case 'x':
                  icon = Icons.tag;
                  color = Colors.blue;
                  break;
                case 'facebook':
                  icon = Icons.facebook;
                  color = Colors.blue.shade800;
                  break;
                case 'linkedin':
                  icon = Icons.work;
                  color = Colors.blue.shade700;
                  break;
                case 'behance':
                  icon = Icons.palette;
                  color = Colors.blue.shade600;
                  break;
                case 'artstation':
                  icon = Icons.brush;
                  color = Colors.blue.shade900;
                  break;
                default:
                  icon = Icons.link;
                  color = AppTheme.primaryColor;
              }
              
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMedium,
                  vertical: AppTheme.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                  border: Border.all(
                    color: color.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16, color: color),
                    const SizedBox(width: AppTheme.spacingXSmall),
                    Text(
                      entry.key,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    return '${months[date.month - 1]} ${date.year}';
  }
}
