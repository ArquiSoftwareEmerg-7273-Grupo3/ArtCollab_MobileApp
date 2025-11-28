import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/projects/data/remote/project_service.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/projects/presentation/pages/project_detail_page.dart';
import 'package:artcollab_mobile/features/projects/presentation/pages/create_project_page.dart';
import 'package:artcollab_mobile/features/projects/presentation/pages/my_applications_page.dart';
import 'package:artcollab_mobile/features/projects/presentation/pages/jobs_published_page.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';
import 'package:artcollab_mobile/shared/widgets/network_image_with_fallback.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage>
    with SingleTickerProviderStateMixin {
  final ProjectService _projectService = ProjectService();
  final UserStorage _userStorage = UserStorage();
  late TabController _tabController;

  List<ProjectDto> _allProjects = [];
  final List<ProjectDto> _myProjects = [];
  bool _isLoadingAll = true;
  bool _isLoadingMy = true;
  String? _userRole;
  bool _isWriter = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserRole();
    _loadAllProjects();
    _loadMyProjects();
  }

  Future<void> _loadUserRole() async {
    final role = await _userStorage.getUserRole();
    setState(() {
      _userRole = role;
      _isWriter = role?.toUpperCase() == 'ESCRITOR';
    });
  }

  Future<void> _loadAllProjects() async {
    setState(() => _isLoadingAll = true);

    final result = await _projectService.getAllProjects();
    if (result is Success<List<ProjectDto>>) {
      setState(() {
        _allProjects = result.data ?? [];
        _isLoadingAll = false;
      });
    } else {
      setState(() => _isLoadingAll = false);
    }
  }

  Future<void> _loadMyProjects() async {
    setState(() => _isLoadingMy = true);

    // TODO: Implementar endpoint para mis proyectos
    setState(() => _isLoadingMy = false);
  }

  void _showCreateProjectDialog() {
    if (!_isWriter) {
      _showWriterOnlyDialog();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateProjectPage(),
        fullscreenDialog: true,
      ),
    ).then((_) {
      _loadAllProjects();
      _loadMyProjects();
    });
  }

  void _showWriterOnlyDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.orange.shade600],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_note,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              const Text(
                '¡Solo para Escritores!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Text(
                'La creación de empleos está reservada para escritores que buscan colaboradores ilustradores.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue.shade700),
                    const SizedBox(width: AppTheme.spacingSmall),
                    Expanded(
                      child: Text(
                        'Como ilustrador, puedes postularte a los empleos disponibles',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              ElegantButton(
                text: 'Entendido',
                type: ElegantButtonType.gradient,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppTheme.backgroundColor,
    body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 170,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.biggest.height;

                return FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
                  title: height < 130
                      ? const Text(
                          "Empleos",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : null,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withOpacity(0.85),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 48,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Empleos",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isWriter
                                  ? "✍️ Encuentra ilustradores talentosos"
                                  : "🎨 Descubre oportunidades creativas",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 3,
                    ),
                    insets: const EdgeInsets.symmetric(horizontal: 32),
                  ),
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    const Tab(
                      icon: Icon(Icons.explore),
                      text: "Explorar",
                    ),
                    Tab(
                      icon: Icon(_isWriter ? Icons.work : Icons.assignment),
                      text: _isWriter ? "Mis Empleos" : "Mis Postulaciones",
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("🔍 Búsqueda próximamente"),
                      backgroundColor: AppTheme.primaryColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              )
            ],
          )
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExploreTab(),
          _buildMyJobsTab(),
        ],
      ),
    ),
    floatingActionButton: _isWriter
        ? FloatingActionButton.extended(
            backgroundColor: AppTheme.primaryColor,
            onPressed: _showCreateProjectDialog,
            icon: const Icon(Icons.add),
            label: const Text("Crear Empleo"),
          )
        : null,
  );
}


  Widget _buildExploreTab() {
    if (_isLoadingAll) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Cargando empleos...',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ],
        ),
      );
    }

    if (_allProjects.isEmpty) {
      return _buildEmptyExploreState();
    }

    return RefreshIndicator(
      onRefresh: _loadAllProjects,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        itemCount: _allProjects.length,
        itemBuilder: (context, index) {
          return _buildProjectCard(_allProjects[index], index);
        },
      ),
    );
  }

  Widget _buildMyJobsTab() {
    // Si es ilustrador, mostrar sus postulaciones
    if (!_isWriter) {
      return const MyApplicationsPage();
    }
    
    // Si es escritor, mostrar sus empleos publicados
    return const JobsPublishedPage();
  }

  Widget _buildEmptyExploreState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    Colors.teal.shade50,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 80,
                color: AppTheme.primaryColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            const Text(
              'No hay empleos disponibles',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              _isWriter
                  ? '¡Sé el primero en publicar un empleo!'
                  : 'Vuelve pronto para ver nuevas oportunidades',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (_isWriter) ...[
              const SizedBox(height: AppTheme.spacingLarge),
              ElegantButton(
                text: 'Crear Primer Empleo',
                icon: Icons.add_circle,
                type: ElegantButtonType.gradient,
                onPressed: _showCreateProjectDialog,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMyJobsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade100,
                    Colors.orange.shade50,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isWriter ? Icons.work_outline : Icons.folder_open,
                size: 80,
                color: Colors.orange.shade400,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            Text(
              _isWriter ? 'No has publicado empleos' : 'No tienes postulaciones',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              _isWriter
                  ? 'Crea tu primer empleo y encuentra al ilustrador perfecto para tu proyecto'
                  : 'Explora los empleos disponibles y postúlate a los que te interesen',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            ElegantButton(
              text: _isWriter ? 'Crear Empleo' : 'Explorar Empleos',
              icon: _isWriter ? Icons.add_circle : Icons.explore,
              type: ElegantButtonType.gradient,
              onPressed: () {
                if (_isWriter) {
                  _showCreateProjectDialog();
                } else {
                  _tabController.animateTo(0);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectDto project, int index) {
    // Colores alternados para variedad visual
    final colors = [
      [Colors.purple.shade400, Colors.purple.shade600],
      [Colors.blue.shade400, Colors.blue.shade600],
      [Colors.pink.shade400, Colors.pink.shade600],
      [Colors.teal.shade400, Colors.teal.shade600],
    ];
    final colorPair = colors[index % colors.length];

    return ElegantCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      padding: EdgeInsets.zero,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailPage(project: project),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con gradiente
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colorPair,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.borderRadiusMedium),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: const Icon(
                    Icons.work,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.titulo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              project.estado,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.descripcion,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingMedium),

                // Presupuesto y fecha
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingSmall),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade50,
                              Colors.green.shade100,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.shade700,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.attach_money,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '\$${project.presupuesto.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSmall,
                        vertical: AppTheme.spacingXSmall,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(project.fechaFin),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'ABIERTO':
        return Colors.green;
      case 'EN_PROGRESO':
        return Colors.orange;
      case 'CERRADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return 'Vencido';
    }
  }
}

// Painter para el patrón decorativo del header
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Dibujar círculos decorativos
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 3; j++) {
        canvas.drawCircle(
          Offset(i * 80.0 + 40, j * 80.0 + 40),
          20,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
