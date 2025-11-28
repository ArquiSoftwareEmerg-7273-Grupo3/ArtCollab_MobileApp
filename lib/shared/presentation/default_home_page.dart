import 'package:artcollab_mobile/features/feed/presentation/pages/feed_page.dart';
import 'package:artcollab_mobile/features/notifications/presentation/pages/notifications_page.dart';
import 'package:artcollab_mobile/features/subscriptions/presentation/pages/subscription_page.dart';
import 'package:artcollab_mobile/features/users/presentation/pages/profile_page.dart';
import 'package:artcollab_mobile/features/portfolio/presentation/pages/portfolio_page.dart';
import 'package:artcollab_mobile/features/projects/presentation/pages/projects_page.dart';
import 'package:artcollab_mobile/features/chat/presentation/pages/chat_list_page.dart';
import 'package:artcollab_mobile/shared/presentation/business_selection.dart';
import 'package:artcollab_mobile/features/users/data/remote/user_service.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/shared/widgets/user_avatar.dart';
import 'package:artcollab_mobile/features/recommendations/presentation/pages/job_recommendations_page.dart';
import 'package:artcollab_mobile/features/recommendations/presentation/pages/illustrator_recommendations_page.dart';
import 'package:artcollab_mobile/features/dashboard/presentation/pages/writer_dashboard_page.dart';
import 'package:artcollab_mobile/features/dashboard/presentation/pages/illustrator_dashboard_page.dart';
import 'package:flutter/material.dart';

class DefaultHomePage extends StatefulWidget {
  const DefaultHomePage({super.key});

  @override
  State<DefaultHomePage> createState() => _DefaultHomePage();
}

class _DefaultHomePage extends State<DefaultHomePage> {
  int _selectedIndex = 0;
  final UserService _userService = UserService();
  final UserStorage _userStorage = UserStorage();
  
  UserProfileDto? _userProfile;
  String? _userRole;
  bool _isLoadingUser = true;

  final List<Widget> _views = [
    const FeedPage(),
    const NotificationsPage(),
    const BusinessSelection()
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final userId = await _userStorage.getUserId();
      final role = await _userStorage.getUserRole();
      
      if (userId != null) {
        final result = await _userService.getUserById(userId);
        
        if (result is Success<UserProfileDto>) {
          setState(() {
            _userProfile = result.data;
            _userRole = role;
            _isLoadingUser = false;
          });
        } else {
          setState(() => _isLoadingUser = false);
        }
      } else {
        setState(() => _isLoadingUser = false);
      }
    } catch (e) {
      setState(() => _isLoadingUser = false);
    }
  }

  bool get _isIllustrator => _userRole?.toUpperCase() == 'ILUSTRADOR';
  bool get _isWriter => _userRole?.toUpperCase() == 'ESCRITOR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'ArtCollab',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatListPage(),
                ),
              );
            },
            tooltip: 'Mensajes',
          ),
        ],
      ),

      // Drawer
      drawer: Drawer(
        backgroundColor: Colors.teal.shade50,
        child: Column(
          children: [
            // Header with user info
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.teal,
              ),
              child: Row(
                children: [
                  _isLoadingUser
                      ? const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                          ),
                        )
                      : UserAvatar(
                          photoUrl: _userProfile?.foto,
                          initials: _userProfile?.initials ?? 'U',
                          radius: 28,
                          backgroundColor: Colors.white,
                          textColor: Colors.teal,
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _userProfile?.fullName ?? 'Usuario ArtCollab',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _userProfile?.email ?? 'user@email.com',
                          style: const TextStyle(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Profile option
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.teal),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),

            const Divider(),

            // Illustrator-specific options
            if (_isIllustrator) ...[
              ListTile(
                leading: const Icon(Icons.dashboard, color: Colors.teal),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IllustratorDashboardPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.recommend, color: Colors.teal),
                title: const Text('Trabajos Recomendados'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'NUEVO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobRecommendationsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.collections, color: Colors.teal),
                title: const Text('Mi Portafolio'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PortfolioPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.work, color: Colors.teal),
                title: const Text('Mis Postulaciones'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad de postulaciones próximamente'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.search, color: Colors.teal),
                title: const Text('Buscar Proyectos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProjectsPage(),
                    ),
                  );
                },
              ),
              const Divider(),
            ],

            // Writer-specific options
            if (_isWriter) ...[
              ListTile(
                leading: const Icon(Icons.dashboard, color: Colors.teal),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WriterDashboardPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.recommend, color: Colors.teal),
                title: const Text('Ilustradores Recomendados'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'NUEVO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IllustratorRecommendationsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.teal),
                title: const Text('Crear Proyecto'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProjectsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder, color: Colors.teal),
                title: const Text('Mis Proyectos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProjectsPage(),
                    ),
                  );
                },
              ),
              const Divider(),
            ],

            // Common options
            ListTile(
              leading: const Icon(Icons.circle_outlined, color: Colors.teal, size: 20),
              title: const Text('Suscripciones'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.circle_outlined, color: Colors.teal, size: 20),
              title: const Text('Anuncia con ArtCollab'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Anuncios seleccionado'),
                    backgroundColor: Colors.teal,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.circle_outlined, color: Colors.teal, size: 20),
              title: const Text('Aprende con ArtCollab'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Aprende con Artcollab seleccionado'),
                    backgroundColor: Colors.teal,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            const Spacer(),

            // Settings button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Abrir configuración'),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.settings),
                label: const Text('Configuración'),
              ),
            ),
          ],
        ),
      ),

      body: _views[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Negocios',
            backgroundColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
