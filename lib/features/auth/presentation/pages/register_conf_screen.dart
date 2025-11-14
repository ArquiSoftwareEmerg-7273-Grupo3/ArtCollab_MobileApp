import 'package:artcollab_mobile/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:artcollab_mobile/features/auth/presentation/blocs/auth_event.dart';
import 'package:artcollab_mobile/features/auth/presentation/blocs/auth_state.dart';
import 'package:artcollab_mobile/features/auth/presentation/pages/signup_screen.dart';
import 'package:artcollab_mobile/shared/presentation/default_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterConfScreen extends StatefulWidget {
  final String nombres;
  final String apellidos;
  final String usuario;
  final String contrasena;

  const RegisterConfScreen({
    super.key,
    required this.nombres,
    required this.apellidos,
    required this.usuario,
    required this.contrasena,
  });

  @override
  State<RegisterConfScreen> createState() => _RegisterConfScreenState();
}

class _RegisterConfScreenState extends State<RegisterConfScreen> {
  final TextEditingController _locController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _prop1Controller = TextEditingController();
  final TextEditingController _prop2Controller = TextEditingController();
  final TextEditingController _prop3Controller = TextEditingController();

  DateTime? selectedDate;

  bool _validateFields() {
    if (_locController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _photoController.text.isEmpty ||
        _descController.text.isEmpty ||
        _prop1Controller.text.isEmpty ||
        _prop2Controller.text.isEmpty ||
        _prop3Controller.text.isEmpty ||
        selectedDate == null) {
      return false;
    }
    return true;
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1960),
      lastDate: DateTime(2025),
      helpText: 'Selecciona tu fecha de nacimiento',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    const teal = Colors.teal;

    return InputDecoration(
      prefixIcon: Icon(icon),
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: teal, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: teal, width: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const teal = Colors.teal;

    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            "Completar Registro",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLoadingState) {
                  const Center(
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()));
                } else if (state is RegisterSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Bienvenid@ a ArtCollab!'),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DefaultHomePage()),
                  );
                } else if (state is AuthErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add_alt_1, size: 80, color: teal[400]),
                    const SizedBox(height: 12),
                    Text(
                      '¡Un paso más para crear tu cuenta!',
                      style: TextStyle(
                        color: teal[800],
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Dirección
                    TextField(
                      controller: _locController,
                      decoration: _inputStyle("Dirección", Icons.location_pin),
                    ),
                    const SizedBox(height: 25),

                    // Teléfono
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputStyle("Teléfono", Icons.phone),
                    ),
                    const SizedBox(height: 25),

                    // Foto (URL)
                    TextField(
                      controller: _photoController,
                      decoration:
                          _inputStyle("URL de Foto de Perfil", Icons.link),
                    ),
                    const SizedBox(height: 25),

                    // Descripción
                    TextField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: _inputStyle(
                          "Descripción personal", Icons.text_snippet),
                    ),
                    const SizedBox(height: 25),

                    // Campos propuestas
                    TextField(
                      controller: _prop1Controller,
                      decoration: _inputStyle("Red Social 1", Icons.lightbulb),
                    ),
                    const SizedBox(height: 25),

                    TextField(
                      controller: _prop2Controller,
                      decoration:
                          _inputStyle("Red Social 2", Icons.lightbulb_outline),
                    ),
                    const SizedBox(height: 25),

                    TextField(
                      controller: _prop3Controller,
                      decoration:
                          _inputStyle("Red Social 3", Icons.brightness_5),
                    ),
                    const SizedBox(height: 25),

                    // Fecha de nacimiento
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Fecha de Nacimiento',
                        style: TextStyle(
                          color: teal[900],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: teal.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: teal.shade600, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              selectedDate != null
                                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                  : 'Seleccionar fecha',
                              style: TextStyle(
                                color: selectedDate != null
                                    ? Colors.black
                                    : Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Botón enviar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_validateFields()) {
                            final String location = _locController.text;
                            final String phone = _phoneController.text;
                            final String photo = _photoController.text;
                            final String descripcion = _descController.text;
                            final String prop1 = _prop1Controller.text;
                            final String prop2 = _prop2Controller.text;
                            final String prop3 = _prop3Controller.text;
                            final String fechaNac =
                                '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}';

                            context.read<AuthBloc>().add(RegisterUser(
                                username: widget.usuario,
                                password: widget.contrasena,
                                ubicacion: location,
                                nombres: widget.nombres,
                                apellidos: widget.apellidos,
                                telefono: phone,
                                foto: photo,
                                descripcion: descripcion,
                                fechaNacimiento: fechaNac,
                                additionalProp1: prop1,
                                additionalProp2: prop2,
                                additionalProp3: prop3));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Por favor completa todos los campos antes de continuar.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          'Crear Cuenta',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        "Volver al Registro inicial",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
