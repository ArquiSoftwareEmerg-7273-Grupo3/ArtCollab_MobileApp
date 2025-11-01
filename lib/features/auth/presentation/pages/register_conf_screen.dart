import 'package:artcollab_mobile/features/auth/presentation/pages/signup_screen.dart';
import 'package:artcollab_mobile/shared/presentation/default_home_page.dart';
import 'package:flutter/material.dart';

class RegisterConfScreen extends StatefulWidget {
  const RegisterConfScreen({super.key});

  @override
  State<RegisterConfScreen> createState() => _RegisterConfScreenState();
}

class _RegisterConfScreenState extends State<RegisterConfScreen> {
  final TextEditingController _locController = TextEditingController();
  DateTime? selectedDate;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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

                // Campo dirección
                TextField(
                  controller: _locController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_pin),
                    labelText: 'Dirección',
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: teal, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: teal.shade200),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Campo fecha de nacimiento
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

                // Botón crear cuenta
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DefaultHomePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text(
                      'Crear Cuenta',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                  },
                  child: const Text(
                    "Volver al Registro inicial",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
