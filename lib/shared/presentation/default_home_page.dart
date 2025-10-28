import 'package:artcollab_mobile/features/feed/presentation/pages/feed_page.dart';
import 'package:artcollab_mobile/features/notifications/presentation/pages/notifications_page.dart';
import 'package:artcollab_mobile/features/users/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

class DefaultHomePage extends StatefulWidget{
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
    const ProfilePage(),
    //const PaymentPage(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row (
          children: [
            /*
            Image.asset(
              'assets/images/1024.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            */
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text('ArtCollab', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio', backgroundColor: Colors.teal),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones', backgroundColor: Colors.teal),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil', backgroundColor: Colors.teal),
          //BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Negocio', backgroundColor: Colors.teal), 
        ],
      ),
    );
  }
}