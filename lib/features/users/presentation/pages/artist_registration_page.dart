import 'package:artcollab_mobile/shared/presentation/artist_home_page.dart';
import 'package:flutter/material.dart';

class ArtistRegistrationPage extends StatefulWidget {
  const ArtistRegistrationPage({super.key});

  @override
  State<ArtistRegistrationPage> createState() => _ArtistRegistrationPageState();
}

class _ArtistRegistrationPageState extends State<ArtistRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _studiesController = TextEditingController();
  final TextEditingController _workStateController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          'Completa los datos',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nombre artístico', _nombreController),
              const SizedBox(height: 16),
              _buildTextField('Centro de Estudios', _studiesController, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField('Estado de trabajo', _workStateController),
              const SizedBox(height: 16),
              _buildTextField('Sitio Web', _websiteController),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArtistHomePage(),
                        ),
                    );
                  }
                },
                child: const Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
    );
  }

}
