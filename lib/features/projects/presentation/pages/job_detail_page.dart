import 'package:flutter/material.dart';
import 'package:artcollab_mobile/shared/widgets/network_image_with_fallback.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';
import 'package:artcollab_mobile/features/projects/data/remote/project_service.dart';
import 'package:artcollab_mobile/features/notifications/data/remote/notification_service.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';

// ContentCard ya está incluido en elegant_card.dart

class JobDetailPage extends StatefulWidget {
  final Map<String, dynamic> job;
  const JobDetailPage({super.key, required this.job});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final ProjectService _projectService = ProjectService();
  final NotificationService _notificationService = NotificationService();
  bool _isApplying = false;

  Future<void> _applyToJob(String message) async {
    if (_isApplying) return;

    setState(() => _isApplying = true);

    try {
      final projectId = widget.job['id'] as int?;
      if (projectId == null) {
        throw Exception('ID de proyecto no disponible');
      }

      final result = await _projectService.createApplication(
        proyectoId: projectId,
        mensaje: message,
      );

      if (result is Success && mounted) {
        // Enviar notificación al escritor
        await _sendApplicationNotification();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: AppTheme.spacingSmall),
                Text('¡Postulación enviada exitosamente!'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result is Error ? (result.message ?? 'Error al postular') : 'Error al postular',
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
    } finally {
      if (mounted) {
        setState(() => _isApplying = false);
      }
    }
  }

  Future<void> _sendApplicationNotification() async {
    try {
      // Obtener información del usuario actual (ilustrador)
      final userStorage = UserStorage();
      final currentUserId = await userStorage.getUserId();
      final currentUserName = await userStorage.getUsername();
      
      if (currentUserId == null) return;
      
      // Obtener ID del escritor del proyecto
      final writerId = widget.job['writerId'] ?? widget.job['author_id'];
      
      if (writerId == null) {
        debugPrint('⚠️ No se pudo obtener el ID del escritor');
        return;
      }
      
      debugPrint('📤 Enviando notificación de nueva postulación');
      debugPrint('   De: $currentUserName (ID: $currentUserId)');
      debugPrint('   Para: Escritor (ID: $writerId)');
      debugPrint('   Proyecto: ${widget.job['title']}');
      
      // TODO: Implementar cuando el backend tenga el endpoint de enviar notificaciones
      // final result = await _notificationService.sendNotification(
      //   recipientId: writerId,
      //   title: 'Nueva Postulación',
      //   message: '${currentUserName ?? "Un ilustrador"} se ha postulado a tu empleo "${widget.job['title']}"',
      //   type: 'JOB_APPLICATION',
      //   relatedId: widget.job['id'],
      // );
      
      debugPrint('✅ Notificación preparada (pendiente implementación backend)');
    } catch (e) {
      debugPrint('💥 Excepción al enviar notificación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.job['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      offset: Offset(0, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageWithFallback(
                    imageUrl: widget.job['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Gradiente para mejorar legibilidad
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
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del autor
                  ElegantCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Publicado por',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.job['author'],
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.job['time'],
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingMedium),

                  // Detalles del trabajo
                  ContentCard(
                    title: 'Detalles del Trabajo',
                    content: Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.category,
                          label: 'Categoría',
                          value: widget.job['category'],
                          color: AppTheme.primaryColor,
                        ),
                        const Divider(height: AppTheme.spacingMedium),
                        _buildDetailRow(
                          icon: Icons.location_on,
                          label: 'Ubicación',
                          value: widget.job['location'],
                          color: Colors.red,
                        ),
                        const Divider(height: AppTheme.spacingMedium),
                        _buildDetailRow(
                          icon: Icons.laptop,
                          label: 'Modalidad',
                          value: widget.job['mode'],
                          color: Colors.blue,
                        ),
                        const Divider(height: AppTheme.spacingMedium),
                        _buildDetailRow(
                          icon: Icons.brush,
                          label: 'Técnica',
                          value: widget.job['technique'],
                          color: Colors.purple,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingMedium),

                  // Presupuesto
                  ElegantCard(
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade50,
                            Colors.green.shade100,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                            ),
                            child: const Icon(
                              Icons.attach_money,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Presupuesto',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.job['budget'] ?? '\$500 - \$1,000',
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingMedium),

                  // Descripción
                  ContentCard(
                    title: 'Descripción',
                    content: Text(
                      widget.job['description'],
                      style: context.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingLarge),

                  // Botón de postulación
                  ElegantButton(
                    text: 'Postular al Trabajo',
                    icon: Icons.send,
                    type: ElegantButtonType.gradient,
                    size: ElegantButtonSize.large,
                    onPressed: () {
                      _showApplicationDialog(context);
                    },
                  ),

                  const SizedBox(height: AppTheme.spacingMedium),

                  // Botón secundario
                  ElegantButton(
                    text: 'Contactar al Autor',
                    icon: Icons.message,
                    type: ElegantButtonType.outline,
                    size: ElegantButtonSize.large,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Función de mensajería próximamente'),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppTheme.spacingXLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showApplicationDialog(BuildContext context) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: Text(
                      'Postular al Trabajo',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              Text(
                'Mensaje de presentación',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              TextField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Cuéntale al autor por qué eres el candidato ideal...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              Row(
                children: [
                  Expanded(
                    child: ElegantButton(
                      text: 'Cancelar',
                      type: ElegantButtonType.outline,
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: ElegantButton(
                      text: _isApplying ? 'Enviando...' : 'Enviar',
                      type: ElegantButtonType.gradient,
                      onPressed: _isApplying ? null : () {
                        final message = messageController.text.trim();
                        if (message.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor escribe un mensaje'),
                              backgroundColor: AppTheme.errorColor,
                            ),
                          );
                          return;
                        }
                        Navigator.pop(dialogContext);
                        _applyToJob(message);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
