import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/projects/data/remote/project_service.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';
import 'job_detail_page.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  final ProjectService _projectService = ProjectService();
  List<ApplicationDto> _applications = [];
  Map<int, ProjectDto> _projects = {};
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = 'Todas';
  final List<String> _filters = ['Todas', 'Pendientes', 'Aprobadas', 'Rechazadas', 'Canceladas'];

  @override
  void initState() {
    super.initState();
    _loadMyApplications();
  }

  Future<void> _loadMyApplications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _projectService.getMyApplications();
      if (result is Success<List<ApplicationDto>>) {
        _applications = result.data ?? [];
        
        // Cargar información de los proyectos
        for (var application in _applications) {
          final projectResult = await _projectService.getProjectById(application.proyectoId);
          if (projectResult is Success<ProjectDto> && projectResult.data != null) {
            _projects[application.proyectoId] = projectResult.data!;
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

  Future<void> _cancelApplication(ApplicationDto application) async {
    final confirmed = await _showCancelDialog(application);
    if (confirmed != true) return;

    try {
      final result = await _projectService.cancelApplication(application.id);
      if (result is Success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: AppTheme.spacingSmall),
                Text('Postulación cancelada'),
              ],
            ),
            backgroundColor: AppTheme.warningColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
          ),
        );
        _loadMyApplications();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result is Error ? (result.message ?? 'Error al cancelar') : 'Error al cancelar',
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

  Future<bool?> _showCancelDialog(ApplicationDto application) {
    final project = _projects[application.proyectoId];
    final projectTitle = project?.titulo ?? 'este empleo';
    
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
                'Cancelar Postulación',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas cancelar tu postulación a "$projectTitle"?',
        ),
        actions: [
          ElegantButton(
            text: 'No',
            type: ElegantButtonType.text,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          ElegantButton(
            text: 'Sí, Cancelar',
            type: ElegantButtonType.secondary,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
  }

  List<ApplicationDto> get _filteredApplications {
    if (_selectedFilter == 'Todas') return _applications;
    
    return _applications.where((app) {
      switch (_selectedFilter) {
        case 'Pendientes':
          return app.estado.toUpperCase() == 'PENDIENTE';
        case 'Aprobadas':
          return app.estado.toUpperCase() == 'APROBADA';
        case 'Rechazadas':
          return app.estado.toUpperCase() == 'RECHAZADA';
        case 'Canceladas':
          return app.estado.toUpperCase() == 'CANCELADA';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filtros
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingSmall),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        
        // Contenido
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? _buildErrorState()
                  : _filteredApplications.isEmpty
                      ? _buildEmptyState()
                      : _buildApplicationsList(),
        ),
      ],
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
              onPressed: _loadMyApplications,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subtitle;
    
    switch (_selectedFilter) {
      case 'Pendientes':
        message = 'No tienes postulaciones pendientes';
        subtitle = 'Las postulaciones que envíes aparecerán aquí mientras esperan respuesta';
        break;
      case 'Aprobadas':
        message = 'No tienes postulaciones aprobadas';
        subtitle = 'Cuando un escritor apruebe tu postulación, aparecerá aquí';
        break;
      case 'Rechazadas':
        message = 'No tienes postulaciones rechazadas';
        subtitle = 'Las postulaciones rechazadas aparecerán aquí';
        break;
      case 'Canceladas':
        message = 'No tienes postulaciones canceladas';
        subtitle = 'Las postulaciones que canceles aparecerán aquí';
        break;
      default:
        message = 'No has enviado postulaciones';
        subtitle = 'Explora empleos disponibles y postúlate a los que te interesen';
    }
    
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
              message,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              subtitle,
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
      onRefresh: _loadMyApplications,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        itemCount: _filteredApplications.length,
        itemBuilder: (context, index) {
          final application = _filteredApplications[index];
          final project = _projects[application.proyectoId];
          return _buildApplicationCard(application, project);
        },
      ),
    );
  }

  Widget _buildApplicationCard(ApplicationDto application, ProjectDto? project) {
    final isPending = application.estado.toUpperCase() == 'PENDIENTE';
    final isApproved = application.estado.toUpperCase() == 'APROBADA';
    final isRejected = application.estado.toUpperCase() == 'RECHAZADA';

    return ElegantCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      onTap: project != null ? () {
        // Navegar al detalle del empleo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailPage(
              job: {
                'id': project.id,
                'title': project.titulo,
                'description': project.descripcion,
                'budget': '\$${project.presupuesto.toStringAsFixed(0)}',
                'deadline': project.fechaFin.toString(),
                'category': project.especialidadProyecto,
                'author': 'Escritor', // TODO: Get writer name
                'time': _formatDate(project.fechaCreacion),
                'image': 'https://via.placeholder.com/400x200', // TODO: Get project image
                'location': 'Remoto',
                'mode': project.modalidadProyecto,
                'technique': project.contratoProyecto,
              },
            ),
          ),
        );
      } : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título del proyecto y estado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  project?.titulo ?? 'Proyecto no disponible',
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
          const SizedBox(height: AppTheme.spacingSmall),
          
          // Información del proyecto
          if (project != null) ...[
            Text(
              project.descripcion,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            
            // Chips informativos
            Wrap(
              spacing: AppTheme.spacingSmall,
              runSpacing: AppTheme.spacingXSmall,
              children: [
                _buildInfoChip(
                  Icons.attach_money,
                  '\$${project.presupuesto.toStringAsFixed(0)}',
                  Colors.green,
                ),
                _buildInfoChip(
                  Icons.calendar_today,
                  _formatDate(application.fechaPostulacion),
                  Colors.blue,
                ),
              ],
            ),
          ],
          const SizedBox(height: AppTheme.spacingMedium),
          
          // Mensaje de postulación si existe
          if (application.mensaje.isNotEmpty) ...[
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
                    'Tu mensaje:',
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXSmall),
                  Text(
                    application.mensaje,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
          ],
          
          // Motivo de rechazo si existe
          if (isRejected && application.respuesta.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                border: Border.all(
                  color: AppTheme.errorColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.errorColor,
                        size: 16,
                      ),
                      const SizedBox(width: AppTheme.spacingXSmall),
                      Text(
                        'Motivo del rechazo:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.errorColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXSmall),
                  Text(
                    application.respuesta,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
          ],
          
          // Acciones
          if (isPending) ...[
            Row(
              children: [
                Expanded(
                  child: ElegantButton(
                    text: 'Ver Empleo',
                    icon: Icons.visibility,
                    type: ElegantButtonType.outline,
                    size: ElegantButtonSize.small,
                    onPressed: project != null ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailPage(
                            job: {
                              'id': project.id,
                              'title': project.titulo,
                              'description': project.descripcion,
                              'budget': '\$${project.presupuesto.toStringAsFixed(0)}',
                              'deadline': project.fechaFin.toString(),
                              'category': project.especialidadProyecto,
                              'author': 'Escritor',
                              'time': _formatDate(project.fechaCreacion),
                              'image': 'https://via.placeholder.com/400x200',
                              'location': 'Remoto',
                              'mode': project.modalidadProyecto,
                              'technique': project.contratoProyecto,
                            },
                          ),
                        ),
                      );
                    } : null,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: ElegantButton(
                    text: 'Cancelar',
                    icon: Icons.close,
                    type: ElegantButtonType.secondary,
                    size: ElegantButtonSize.small,
                    onPressed: () => _cancelApplication(application),
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
                      '¡Felicidades! Tu postulación fue aprobada. Puedes contactar al escritor por chat.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.successColor,
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
        return 'Pendiente';
      case 'APROBADA':
        return 'Aprobada';
      case 'RECHAZADA':
        return 'Rechazada';
      case 'CANCELADA':
        return 'Cancelada';
      default:
        return status;
    }
  }
}
