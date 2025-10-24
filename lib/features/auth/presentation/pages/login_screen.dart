import 'package:artcollab_mobile/features/auth/presentation/blocs/hidden_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  
                  child: Image.asset(
                    'assets/images/bus-stop-location-outline-icon.png',
                    fit: BoxFit.contain,
                    height: 128,
                  ),
                ),
                */
                const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Iniciar Sesión', style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _mailController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(),
                        label: Text('Correo electrónico')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<HiddenPasswordCubit, bool>(
                      builder: (context, state) {
                    return TextField(
                      obscureText: state,
                      controller: _pwController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                              onPressed: () {
                                context
                                    .read<HiddenPasswordCubit>()
                                    .changeVisibility();
                              },
                              icon: Icon(state
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          border: const OutlineInputBorder(),
                          label: const Text('Contraseña')),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        final String mail = _mailController.text;
                        final String password = _pwController.text;
                        /*
                        context.read<AuthBloc>().add(
                            AuthorizeUser(user: username, password: password));
                        */
                      },
                      child: const Text('Iniciar Sesion'),
                    ),
                  ),
                )
              ],
            ),
          ),
        /*
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoadingState) {
              const Center(
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator()));
            } else if (state is AuthLoadedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Welcome back, ${state.user.username}.'),
                ),
              );
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  
                  child: Image.asset(
                    'assets/images/bus-stop-location-outline-icon.png',
                    fit: BoxFit.contain,
                    height: 128,
                  ),
                ),
                */
                const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Iniciar Sesión', style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _userController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        label: Text('Usuario')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<HiddenPasswordCubit, bool>(
                      builder: (context, state) {
                    return TextField(
                      obscureText: state,
                      controller: _pwController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                              onPressed: () {
                                context
                                    .read<HiddenPasswordCubit>()
                                    .changeVisibility();
                              },
                              icon: Icon(state
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          border: const OutlineInputBorder(),
                          label: const Text('Contraseña')),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        final String username = _userController.text;
                        final String password = _pwController.text;
                        /*
                        context.read<AuthBloc>().add(
                            AuthorizeUser(user: username, password: password));
                        */
                      },
                      child: const Text('Iniciar Sesion'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        */
      ),
    );
  }
}