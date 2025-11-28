import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/projects/data/remote/project_service.dart';
import 'package:artcollab_mobile/features/users/data/remote/user_service.dart';
import 'package:artcollab_mobile/features/chat/data/remote/chat_service.dart';
import 'package:artcollab_mobile/features/notifications/data/remote/notification_service.dart';
import 'package:artcollab_mobile/features/users/presentation/pages/illustrator_profile_page.dart';
import 'package:artcollab_mobile/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';
import 'package:artcollab_mobile/shared/widgets/user_avatar.dart';

class JobApplicationsPage extends StatefulWidget {
  final int projectId;
  final String projectTitle;

  const JobApplicationsPage({
    super.key,
    required this.projectId,
    required this.projectTitle,
  });

  @override
  State<JobApplicationsPage> createState() => _JobApplicationsPageState();
}

class _JobApplicationsPageState extends State<JobApplicationsPage> {
  final ProjectService _projectService = ProjectService();
  final UserService _userService = UserService();
  final ChatService _chatService = ChatService();
  final NotificationService _notificationService = NotificationService();

  List<ApplicationDto> _applications = [];
  Map<int, UserProfileDto> _illustratorProfiles = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _projectService.getApplicationsByProyectoId(widget.projectId);

      if (result is Success<List<ApplicationDto>>) {
        _applications = result.data ?? [];

        // Cargar perfiles de ilustradores
        for (var application in _applications) {
          final profileResult = await _userService.getUserById(application.ilustradorId);
          if (profileResult is Success<UserProfileDto> && profileResult.data != null) {
            _illustratorProfiles[application.ilustradorId] = profileResult.data!;
          }
        }

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = (result as Error).message ?? 'Error al cargar postulaciones';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error inesperado: $e';
      });
    }
  }

  Future<void> _approveApplication(ApplicationDto application) async {
    final confirmed = await _showApproveDialog(application);
    if (confirmed != true) return;

    try {
      final result = await _projectService.approveApplication(
        application.id,
        '¡Felicidades! Tu postulación ha sido aprobada.',
      );

      if (result is Success && mounted) {
        // Crear chat automáticamente
        await _createChatWithIllustrator(application.ilustradorId);
        
        // Enviar notificación al ilustrador
        await _sendApprovalNotification(application);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: AppTheme.spacingSmall),
                Text('Postulación aprobada exitosamente'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
          ),
        );

        _loadApplications();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result is Error ? (result.message ?? 'Error al aprobar') : 'Error al aprobar',
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _rejectApplication(ApplicationDto application) async {
    final reason = await _showRejectDialog(application);
    if (reason == null) return;

    try {
      final result = await _projectService.rejectApplication(
        application.id,
        reason.isEmpty ? 'No se especificó un motivo' : reason,
      );

      if (result is Success && mounted) {
        // Enviar notificación al ilustrador
        await _sendRejectionNotification(application, reason);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: AppTheme.spacingSmall),
                Text('Postulación rechazada'),
              ],
            ),
            backgroundColor: AppTheme.warningColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
          ),
        );

        _loadApplications();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result is Error ? (result.message ?? 'Error al rechazar') : 'Error al rechazar',
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _createChatWithIllustrator(int illustratorId) async {
    try {
      // Get current user ID from storage
      final userStorage = UserStorage();
      final currentUserId = await userStorage.getUserId();
      
      if (currentUserId != null) {
        await _chatService.createChat(currentUserId, illustratorId);
      }
    } catch (e) {
      // Silently fail - chat creation is not critical
      debugPrint('Error creating chat: $e');
    }
  }

  Future<bool?> _showApproveDialog(ApplicationDto application) {
    final profile = _illustratorProfiles[application.ilustradorId];
    final name = profile?.fullName ?? 'este ilustrador';

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppTheme.successColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            const Expanded(
              child: Text(
                'Aprobar Postulación',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro de que deseas aprobar la postulación de $name?',
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                border: Border.all(
                  color: AppTheme.infoColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.infoColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Expanded(
                    child: Text(
                      'Se creará automáticamente un chat para coordinar el proyecto.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.infoColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElegantButton(
            text: 'Cancelar',
            type: ElegantButtonType.text,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          ElegantButton(
            text: 'Aprobar',
            type: ElegantButtonType.primary,
            icon: Icons.check,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
  }

  Future<String?> _showRejectDialog(ApplicationDto application) {
    final profile = _illustratorProfiles[application.ilustradorId];
    final name = profile?.fullName ?? 'este ilustrador';
    final reasonController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              child: const Icon(
                Icons.cancel,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            const Expanded(
              child: Text(
                'Rechazar Postulación',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro de que deseas rechazar la postulación de $name?',
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'Motivo (opcional)',
                hintText: 'Explica por qué rechazas esta postulación...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
                prefixIcon: const Icon(Icons.message),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          ElegantButton(
            text: 'Cancelar',
            type: ElegantButtonType.text,
            onPressed: () => Navigator.pop(dialogContext),
          ),
          ElegantButton(
            text: 'Rechazar',
            type: ElegantButtonType.secondary,
            icon: Icons.close,
            onPressed: () => Navigator.pop(dialogContext, reasonController.text),
          ),
        ],
      ),
    );
  }

  void _viewIllustratorProfile(int illustratorId) {
    final profile = _illustratorProfiles[illustratorId];
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IllustratorProfilePage(
          illustratorId: illustratorId,
          initialProfile: profile,
        ),
      ),
    );
  }

  Future<void> _contactIllustrator(int illustratorId, UserProfileDto? profile) async {
    try {
      debugPrint('📱 Iniciando contacto con ilustrador ID: $illustratorId');
      
      // Obtener ID del usuario actual
      final userStorage = UserStorage();
      final currentUserId = await userStorage.getUserId();
      
      if (currentUserId == null) {
        throw Exception('No se pudo obtener el ID del usuario actual');
      }
      
      debugPrint('👤 Usuario actual ID: $currentUserId');
      
      // Crear o obtener chat existente
      final result = await _chatService.createChat(currentUserId, illustratorId);
      
      if (result is Success && mounted) {
        debugPrint('✅ Chat creado/obtenido exitosamente');
        
        // Navegar al chat
        if (result.data != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailPage(
                chat: result.data!,
                otherUserName: profile?.fullName ?? 'Ilustrador',
                otherUserPhoto: profile?.foto,
                otherUserInitials: profile?.initials ?? '?',
              ),
            ),
          );
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: Text(
                    'Chat con ${profile?.fullName ?? "ilustrador"} iniciado',
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
          ),
        );
      } else if (mounted) {
        final errorMessage = result is Error ? (result.message ?? 'Error al crear chat') : 'Error al crear chat';
        debugPrint('❌ Error al crear chat: $errorMessage');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      debugPrint('💥 Excepción al contactar ilustrador: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _sendApprovalNotification(ApplicationDto application) async {
    try {
      final profile = _illustratorProfiles[application.ilustradorId];
      
      debugPrint('📤 Enviando notificación de aprobación');
      debugPrint('   Para: ${profile?.fullName} (ID: ${application.ilustradorId})');
      debugPrint('   Proyecto: ${widget.projectTitle}');
      
      // TODO: Implementar cuando el backend tenga el endpoint de enviar notificaciones
      // final result = await _notificationService.sendNotification(
      //   recipientId: application.ilustradorId,
      //   title: '¡Postulación Aprobada!',
      //   message: 'Tu postulación al empleo "${widget.projectTitle}" ha sido aprobada',
      //   type: 'JOB_APPROVED',
      //   relatedId: widget.projectId,
      // );
      
      debugPrint('✅ Notificación de aprobación preparada (pendiente implementación backend)');
    } catch (e) {
      debugPrint('💥 Excepción al enviar notificación de aprobación: $e');
    }
  }

  Future<void> _sendRejectionNotification(ApplicationDto application, String reason) async {
    try {
      final profile = _illustratorProfiles[application.ilustradorId];
      
      debugPrint('📤 Enviando notificación de rechazo');
      debugPrint('   Para: ${profile?.fullName} (ID: ${application.ilustradorId})');
      debugPrint('   Proyecto: ${widget.projectTitle}');
      
      final message = reason.isEmpty 
          ? 'Tu postulación al empleo "${widget.projectTitle}" ha sido rechazada'
          : 'Tu postulación al empleo "${widget.projectTitle}" ha sido rechazada. Motivo: $reason';
      
      // TODO: Implementar cuando el backend tenga el endpoint de enviar notificaciones
      // final result = await _notificationService.sendNotification(
      //   recipientId: application.ilustradorId,
      //   title: 'Postulación Rechazada',
      //   message: message,
      //   type: 'JOB_REJECTED',
      //   relatedId: widget.projectId,
      // );
      
      debugPrint('✅ Notificación de rechazo preparada (pendiente implementación backend)');
    } catch (e) {
      debugPrint('💥 Excepción al enviar notificación de rechazo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Postulantes'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : _applications.isEmpty
                  ? _buildEmptyState()
                  : _buildApplicationsList(),
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
              'Error al cargar postulaciones',
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
              onPressed: _loadApplications,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Sin postulaciones aún',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              'Cuando los ilustradores se postulen a "${widget.projectTitle}", aparecerán aquí.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsList() {
    return RefreshIndicator(
      onRefresh: _loadApplications,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        itemCount: _applications.length,
        itemBuilder: (context, index) {
          final application = _applications[index];
          final profile = _illustratorProfiles[application.ilustradorId];
          return _buildApplicationCard(application, profile);
        },
      ),
    );
  }

  Widget _buildApplicationCard(ApplicationDto application, UserProfileDto? profile) {
    final estado = application.estado.toUpperCase();
    final isPending = estado == 'PENDIENTE' || estado == 'EN_ESPERA';
    final isApproved = estado == 'APROBADA';
    final isRejected = estado == 'RECHAZADA';

    return ElegantCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con avatar y nombre
          Row(
            children: [
              UserAvatar(
                photoUrl: profile?.foto,
                initials: profile?.initials ?? '?',
                radius: 28,
              ),
              const SizedBox(width: AppTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.fullName ?? 'Ilustrador',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXSmall),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: AppTheme.spacingXSmall),
                        Text(
                          _formatDate(application.fechaPostulacion),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Badge de estado
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSmall,
                  vertical: AppTheme.spacingXSmall,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(application.estado).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                  border: Border.all(
                    color: _getStatusColor(application.estado),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _getStatusText(application.estado),
                  style: TextStyle(
                    color: _getStatusColor(application.estado),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Información adicional del ilustrador
          if (profile != null) ...[
            const SizedBox(height: AppTheme.spacingMedium),
            const Divider(),
            const SizedBox(height: AppTheme.spacingSmall),
            if (profile.email.isNotEmpty)
              _buildInfoRow(Icons.email, profile.email),
            if (profile.telefono != null)
              _buildInfoRow(Icons.phone, profile.telefono!),
            if (profile.ubicacion != null)
              _buildInfoRow(Icons.location_on, profile.ubicacion!),
          ],

          const SizedBox(height: AppTheme.spacingMedium),

          // Mensaje de postulación si existe
          if (application.mensaje.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingMedium),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.message,
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: AppTheme.spacingXSmall),
                      Text(
                        'Mensaje de presentación:',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXSmall),
                  Text(
                    application.mensaje,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppTheme.spacingMedium),

          // Acciones
          if (isPending) ...[
            Row(
              children: [
                Expanded(
                  child: ElegantButton(
                    text: 'Ver Perfil',
                    icon: Icons.person,
                    type: ElegantButtonType.outline,
                    size: ElegantButtonSize.small,
                    onPressed: () => _viewIllustratorProfile(application.ilustradorId),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: ElegantButton(
                    text: 'Rechazar',
                    icon: Icons.close,
                    type: ElegantButtonType.secondary,
                    size: ElegantButtonSize.small,
                    onPressed: () => _rejectApplication(application),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: ElegantButton(
                    text: 'Aprobar',
                    icon: Icons.check,
                    type: ElegantButtonType.gradient,
                    size: ElegantButtonSize.small,
                    onPressed: () => _approveApplication(application),
                  ),
                ),
              ],
            ),
          ] else if (isApproved) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                border: Border.all(
                  color: AppTheme.successColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.successColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Expanded(
                    child: Text(
                      'Postulación aprobada',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Row(
              children: [
                Expanded(
                  child: ElegantButton(
                    text: 'Ver Perfil',
                    icon: Icons.person,
                    type: ElegantButtonType.outline,
                    size: ElegantButtonSize.small,
                    onPressed: () => _viewIllustratorProfile(application.ilustradorId),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  flex: 2,
                  child: ElegantButton(
                    text: 'Contactar por Chat',
                    icon: Icons.message,
                    type: ElegantButtonType.gradient,
                    size: ElegantButtonSize.small,
                    onPressed: () => _contactIllustrator(application.ilustradorId, profile),
                  ),
                ),
              ],
            ),
          ] else if (isRejected) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                border: Border.all(
                  color: AppTheme.errorColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: AppTheme.errorColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Expanded(
                    child: Text(
                      'Postulación rechazada',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (application.respuesta.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacingSmall),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSmall),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Motivo:',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXSmall),
                    Text(
                      application.respuesta,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXSmall),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes} minutos';
      }
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDIENTE':
      case 'EN_ESPERA':
        return AppTheme.warningColor;
      case 'APROBADA':
        return AppTheme.successColor;
      case 'RECHAZADA':
        return AppTheme.errorColor;
      case 'CANCELADA':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDIENTE':
      case 'EN_ESPERA':
        return 'Pendiente';
      case 'APROBADA':
        return 'Aprobada';
      case 'RECHAZADA':
        return 'Rechazada';
      case 'CANCELADA':
        return 'Cancelada';
      default:
        return status.replaceAll('_', ' ');
    }
  }
}
