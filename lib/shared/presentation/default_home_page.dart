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
  int _selectedIndex = 0; // Para controlar la pestaña seleccionada

  // Lista de widgets para las diferentes vistas
  final List<Widget> _views = [
    const FeedPage(),
    const NotificationsPage(),
    const BusinessSelection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10.0),
                  backgroundColor: Colors.white, 
                  foregroundColor: Colors.white, 
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.black,
                ),
                ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text('ArtCollab',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        backgroundColor: Colors.teal,
      ),
      body: _views[_selectedIndex], // Muestra la vista seleccionada
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex, // Index de la pestaña seleccionada
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Cambia la pestaña seleccionada
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
              backgroundColor: Colors.teal),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificaciones',
              backgroundColor: Colors.teal),
          BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Negocios',
              backgroundColor: Colors.teal),
        ],
      ),
    );
  }
}
