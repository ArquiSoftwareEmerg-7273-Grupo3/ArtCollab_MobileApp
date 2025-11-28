import 'package:artcollab_mobile/features/auth/presentation/pages/login_screen.dart';
import 'package:artcollab_mobile/features/users/data/remote/user_service.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';
import 'package:artcollab_mobile/core/storage/token_storage.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/shared/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const ProfileContent(),
    );
  }
}

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final UserService _userService = UserService();
  final UserStorage _userStorage = UserStorage();
  final TokenStorage _tokenStorage = TokenStorage();
  
  UserProfileDto? _userProfile;
  bool _isLoading = true;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    
    try {
      // Get user ID from storage
      final userId = await _userStorage.getUserId();
      final role = await _userStorage.getUserRole();
      
      if (userId != null) {
        final result = await _userService.getUserById(userId);
        
        if (result is Success<UserProfileDto>) {
          setState(() {
            _userProfile = result.data;
            _userRole = role;
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  bool get _isIllustrator => _userRole?.toUpperCase() == 'ILUSTRADOR';
  bool get _isWriter => _userRole?.toUpperCase() == 'ESCRITOR';

  Future<void> _logout() async {
    await _tokenStorage.clearToken();
    await _userStorage.clearUser();
    
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_userProfile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Error al cargar el perfil'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserProfile,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with user info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.teal.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                // Profile photo
                UserAvatar(
                  photoUrl: _userProfile!.foto,
                  initials: _userProfile!.initials,
                  radius: 55,
                  backgroundColor: Colors.white,
                  textColor: Colors.teal,
                ),
                const SizedBox(height: 15),
                Text(
                  _userProfile!.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _getRoleDisplayName(),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // User information card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  children: [
                    if (_userProfile!.email.isNotEmpty)
                      InfoTile(
                        icon: Icons.email_outlined,
                        label: 'Correo',
                        value: _userProfile!.email,
                      ),
                    if (_userProfile!.email.isNotEmpty) const Divider(),
                    if (_userProfile!.telefono != null)
                      InfoTile(
                        icon: Icons.phone_android_outlined,
                        label: 'Teléfono',
                        value: _userProfile!.telefono!,
                      ),
                    if (_userProfile!.telefono != null) const Divider(),
                    if (_userProfile!.ubicacion != null)
                      InfoTile(
                        icon: Icons.location_on_outlined,
                        label: 'Ubicación',
                        value: _userProfile!.ubicacion!,
                      ),
                    if (_userProfile!.ubicacion != null) const Divider(),
                    if (_userProfile!.descripcion != null)
                      InfoTile(
                        icon: Icons.info_outline,
                        label: 'Descripción',
                        value: _userProfile!.descripcion!,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Social networks card
          if (_userProfile!.redesSociales != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Redes Sociales',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.camera_alt_outlined, color: Colors.teal),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.facebook, color: Colors.tealAccent),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.alternate_email, color: Colors.teal),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),

          // Illustrator-specific features
          if (_isIllustrator) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Funciones de Ilustrador',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.collections, color: Colors.teal),
                        title: const Text('Mi Portafolio'),
                        subtitle: const Text('Ver y gestionar mis ilustraciones'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to portfolio
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidad de portafolio próximamente'),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.work, color: Colors.teal),
                        title: const Text('Mis Postulaciones'),
                        subtitle: const Text('Ver proyectos a los que postulé'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to applications
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidad de postulaciones próximamente'),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.search, color: Colors.teal),
                        title: const Text('Buscar Proyectos'),
                        subtitle: const Text('Explorar oportunidades'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to projects
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidad de proyectos próximamente'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Writer-specific features
          if (_isWriter) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Funciones de Escritor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.add_circle, color: Colors.teal),
                        title: const Text('Crear Proyecto'),
                        subtitle: const Text('Publicar una nueva oportunidad'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to create project
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidad de crear proyecto próximamente'),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.folder, color: Colors.teal),
                        title: const Text('Mis Proyectos'),
                        subtitle: const Text('Gestionar mis proyectos'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to my projects
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidad de mis proyectos próximamente'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad de editar perfil próximamente'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar perfil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.teal),
                  label: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.teal),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.teal),
                    minimumSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _getRoleDisplayName() {
    if (_isIllustrator) return 'Ilustrador';
    if (_isWriter) return 'Escritor';
    return 'Usuario de ArtCollab';
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
