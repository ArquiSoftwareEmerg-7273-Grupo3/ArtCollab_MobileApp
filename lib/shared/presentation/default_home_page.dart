import 'package:artcollab_mobile/features/feed/presentation/pages/feed_page.dart';
import 'package:artcollab_mobile/features/notifications/presentation/pages/notifications_page.dart';
import 'package:artcollab_mobile/features/users/presentation/pages/profile_page.dart';
import 'package:artcollab_mobile/shared/presentation/business_selection.dart';
import 'package:flutter/material.dart';

class DefaultHomePage extends StatefulWidget {
  const DefaultHomePage({super.key});

  @override
  State<DefaultHomePage> createState() => _DefaultHomePage();
}

class _DefaultHomePage extends State<DefaultHomePage> {
  int _selectedIndex = 0; // Controla la pestaña seleccionada

  final List<Widget> _views = [
    const FeedPage(),
    const NotificationsPage(),
    const BusinessSelection()
  ];

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
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        backgroundColor: Colors.teal,
      ),

      // 🔹 Drawer agregado
      drawer: Drawer(
        backgroundColor: Colors.teal.shade50,
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 32, color: Colors.teal),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Usuario ArtCollab',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text('user@email.com',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 Opción para ir al perfil
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.teal),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
            ),

            const Divider(),

            // 🔹 Placeholders (para llenar en el futuro)
            ...List.generate(6, (index) {
              return ListTile(
                leading: const Icon(Icons.circle_outlined,
                    color: Colors.teal, size: 20),
                title: Text('Opción ${index + 1}'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Opción ${index + 1} seleccionada'),
                    backgroundColor: Colors.teal,
                    duration: const Duration(seconds: 1),
                  ));
                },
              );
            }),

            const Spacer(),

            // 🔹 Botón de configuración al final
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Abrir configuración'),
                    backgroundColor: Colors.teal,
                  ));
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
