import 'package:artcollab_mobile/features/feed/presentation/pages/feed_page.dart';
import 'package:artcollab_mobile/features/notifications/presentation/pages/notifications_page.dart';
import 'package:artcollab_mobile/features/projects/presentation/pages/jobs_published_page.dart';
import 'package:artcollab_mobile/features/projects/presentation/pages/chat_page.dart';
import 'package:artcollab_mobile/features/projects/presentation/pages/recommendations_page.dart';
import 'package:artcollab_mobile/features/subscriptions/presentation/pages/subscription_page.dart';
import 'package:artcollab_mobile/features/users/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

class WriterHomePage extends StatefulWidget {
  const WriterHomePage({super.key});

  @override
  State<WriterHomePage> createState() => _WriterHomePage();
}

class _WriterHomePage extends State<WriterHomePage> {
  int _selectedIndex = 0; // Controla la pestaña seleccionada

  final List<Widget> _views = [
    const FeedPage(),
    const JobsPublishedPage(),
    const RecommendationsPage(),
    const NotificationsPage(),
    const ChatPage()
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        backgroundColor: Colors.teal,
      ),

      // Drawer agregado
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

            // Opción para ir al perfil
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

            ListTile(
              leading: const Icon(Icons.circle_outlined,
                  color: Colors.teal, size: 20),
              title: const Text('Suscripciones'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.circle_outlined,
                  color: Colors.teal, size: 20),
              title: const Text('Anuncia con ArtCollab'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Anuncios seleccionado'),
                  backgroundColor: Colors.teal,
                  duration: Duration(seconds: 1),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.circle_outlined,
                  color: Colors.teal, size: 20),
              title: const Text('Aprende con ArtCollab'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Aprende con Artcollab seleccionado'),
                  backgroundColor: Colors.teal,
                  duration: Duration(seconds: 1),
                ));
              },
            ),

            const Spacer(),

            // Botón de configuración al final
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
            icon: Icon(Icons.business_center),
            label: 'Ofertas',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Recommendaciones',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Messages',
            backgroundColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
