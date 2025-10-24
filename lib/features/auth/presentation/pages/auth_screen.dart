import 'package:artcollab_mobile/features/auth/presentation/pages/login_screen.dart';
import 'package:artcollab_mobile/features/auth/presentation/pages/signup_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2, 
        child: Scaffold(appBar: AppBar(
              backgroundColor: Colors.teal,
              title: Row(
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
                    child: const Text('ArtCollab',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Regístrate'),
                  Tab(text: 'Iniciar Sesión')
                ],
              ),
            ),
             body: const TabBarView(
              children: [
                SignupScreen(),
                LoginScreen()
              ],
            ),
        )
        ),
    );
  }

}