import 'package:flutter/material.dart';
import 'job_applications_page.dart';
import 'package:artcollab_mobile/features/projects/data/remote/project_service.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';

class JobsPublishedPage extends StatefulWidget {
  const JobsPublishedPage({super.key});

  @override
  State<JobsPublishedPage> createState() => _JobsPublishedPageState();
}

class _JobsPublishedPageState extends State<JobsPublishedPage> {
  final ProjectService _projectService = ProjectService();
  
  List<ProjectDto> _projects = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMyProjects();
  }

  Future<void> _loadMyProjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _projectService.getMyProjects();

      if (result is Success<List<ProjectDto>>) {
        setState(() {
          _projects = result.data ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = (result as Error).message ?? 'Error al cargar proyectos';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error inesperado: $e';
      });
    }
  }

  Future<void> _closeProject(ProjectDto project) async {
    final confirmed = await _showCloseJobDialog(context, project.titulo);
    if (confirmed != true) return;

    try {
      final result = await _projectService.closeProject(project.id);

      if (result is Success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: AppTheme.spacingSmall),
                Text('Empleo cerrado exitosamente'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
          ),
        );
        _loadMyProjects();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result is Error ? (result.message ?? 'Error al cerrar') : 'Error al cerrar',
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

  Future<void> _finalizeProject(ProjectDto project) async {
    final confirmed = await _showFinalizeJobDialog(context, project.titulo);
    if (confirmed != true) return;

    try {
      final result = await _projectService.finalizeProject(project.id);

      if (result is Success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: AppTheme.spacingSmall),
                Text('Empleo finalizado exitosamente'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
          ),
        );
        _loadMyProjects();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result is Error ? (result.message ?? 'Error al finalizar') : 'Error al finalizar',
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

  Future<bool?> _showCloseJobDialog(BuildContext context, String jobTitle) {
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
                color: AppTheme.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              child: const Icon(
                Icons.warning,
                color: AppTheme.warningColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            const Expanded(
              child: Text(
                'Cerrar Empleo',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas cerrar "$jobTitle"? No podrás recibir más postulaciones.',
        ),
        actions: [
          ElegantButton(
            text: 'Cancelar',
            type: ElegantButtonType.text,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          ElegantButton(
            text: 'Cerrar Empleo',
            type: ElegantButtonType.secondary,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showFinalizeJobDialog(BuildContext context, String jobTitle) {
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
                'Finalizar Empleo',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas finalizar "$jobTitle"? Esto marcará el empleo como completado.',
        ),
        actions: [
          ElegantButton(
            text: 'Cancelar',
            type: ElegantButtonType.text,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          ElegantButton(
            text: 'Finalizar',
            type: ElegantButtonType.gradient,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : _projects.isEmpty
                  ? _buildEmptyState()
                  : _buildProjectsList(),
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
              'Error al cargar empleos',
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
              onPressed: _loadMyProjects,
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
              Icons.work_outline,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'No has publicado empleos',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              'Publica tu primer empleo para encontrar ilustradores talentosos',
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

  Widget _buildProjectsList() {
    return RefreshIndicator(
      onRefresh: _loadMyProjects,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return _buildJobCard(project);
        },
      ),
    );
  }

  Widget _buildJobCard(ProjectDto project) {
    final isOpen = project.estado.toUpperCase() == 'ABIERTO';
    final isClosed = project.estado.toUpperCase() == 'CERRADO';
    final isCompleted = project.estado.toUpperCase() == 'FINALIZADO';

    return ElegantCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobApplicationsPage(
              projectId: project.id,
              projectTitle: project.titulo,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y badge de estado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  project.titulo,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSmall),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSmall,
                  vertical: AppTheme.spacingXSmall,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(project.estado).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                  border: Border.all(
                    color: _getStatusColor(project.estado),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _getStatusText(project.estado),
                  style: TextStyle(
                    color: _getStatusColor(project.estado),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingSmall),

          // Descripción
          Text(
            project.descripcion,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppTheme.spacingMedium),

          // Información del proyecto
          Wrap(
            spacing: AppTheme.spacingMedium,
            runSpacing: AppTheme.spacingSmall,
            children: [
              _buildInfoChip(
                Icons.attach_money,
                '\$${project.presupuesto.toStringAsFixed(0)}',
                Colors.green,
              ),
              _buildInfoChip(
                Icons.calendar_today,
                _formatDate(project.fechaFin),
                Colors.blue,
              ),
              _buildInfoChip(
                Icons.people,
                '${project.postulacionesActuales}/${project.maxPostulaciones}',
                AppTheme.primaryColor,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMedium),

          // Detalles adicionales
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSmall),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            child: Column(
              children: [
                _buildDetailRow('Modalidad', _formatEnum(project.modalidadProyecto)),
                const Divider(height: AppTheme.spacingSmall),
                _buildDetailRow('Contrato', _formatEnum(project.contratoProyecto)),
                const Divider(height: AppTheme.spacingSmall),
                _buildDetailRow('Especialidad', _formatEnum(project.especialidadProyecto)),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingMedium),

          // Acciones
          if (isOpen) ...[
            Row(
              children: [
                Expanded(
                  child: ElegantButton(
                    text: 'Ver Postulantes',
                    icon: Icons.people,
                    type: ElegantButtonType.primary,
                    size: ElegantButtonSize.small,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobApplicationsPage(
                            projectId: project.id,
                            projectTitle: project.titulo,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: ElegantButton(
                    text: 'Cerrar',
                    icon: Icons.close,
                    type: ElegantButtonType.secondary,
                    size: ElegantButtonSize.small,
                    onPressed: () => _closeProject(project),
                  ),
                ),
              ],
            ),
          ] else if (isClosed) ...[
            Row(
              children: [
                Expanded(
                  child: ElegantButton(
                    text: 'Ver Postulantes',
                    icon: Icons.people,
                    type: ElegantButtonType.outline,
                    size: ElegantButtonSize.small,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobApplicationsPage(
                            projectId: project.id,
                            projectTitle: project.titulo,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: ElegantButton(
                    text: 'Finalizar',
                    icon: Icons.check,
                    type: ElegantButtonType.gradient,
                    size: ElegantButtonSize.small,
                    onPressed: () => _finalizeProject(project),
                  ),
                ),
              ],
            ),
          ] else if (isCompleted) ...[
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
                      'Empleo completado',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSmall,
        vertical: AppTheme.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
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
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return 'Vencido';
    } else if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Mañana';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatEnum(String value) {
    return value.replaceAll('_', ' ').toLowerCase().split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ABIERTO':
        return AppTheme.successColor;
      case 'EN_PROGRESO':
        return AppTheme.infoColor;
      case 'CERRADO':
        return AppTheme.warningColor;
      case 'FINALIZADO':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'ABIERTO':
        return 'Abierto';
      case 'EN_PROGRESO':
        return 'En Progreso';
      case 'CERRADO':
        return 'Cerrado';
      case 'FINALIZADO':
        return 'Finalizado';
      default:
        return status;
    }
  }
}
