import 'package:artcollab_mobile/features/auth/presentation/blocs/hidden_password_cubit.dart';
import 'package:artcollab_mobile/features/auth/presentation/pages/login_screen.dart';
import 'package:artcollab_mobile/features/auth/presentation/pages/register_conf_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'AppCollab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle,
                    size: 90, color: colorScheme.primary),
                const SizedBox(height: 8),
                Text(
                  'Crear cuenta',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Nombres
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'Nombres',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Apellidos
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    labelText: 'Apellidos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Correo electrónico
                TextField(
                  controller: _mailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail_outline),
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Contraseña
                BlocBuilder<HiddenPasswordCubit, bool>(
                  builder: (context, hidden) {
                    return TextField(
                      controller: _pwController,
                      obscureText: hidden,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            context
                                .read<HiddenPasswordCubit>()
                                .changeVisibility();
                          },
                          icon: Icon(
                            hidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Botón siguiente
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterConfScreen(),
                        ),
                      );
                    },
                    label: const Text(
                      'Siguiente',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Línea divisoria
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    )),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('o'),
                    ),
                    Expanded(
                        child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    )),
                  ],
                ),
                const SizedBox(height: 16),

                // Botón para iniciar sesión
                TextButton(
                  onPressed: () {
                    // Aquí puedes navegar a tu pantalla de Login
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: '¿Ya tienes una cuenta? ',
                      style: TextStyle(color: Colors.grey.shade700),
                      children: [
                        TextSpan(
                          text: 'Inicia sesión aquí',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
