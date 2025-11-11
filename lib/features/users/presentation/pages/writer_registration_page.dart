import 'package:artcollab_mobile/shared/presentation/writer_home_page.dart';
import 'package:flutter/material.dart';

class WriterRegistrationPage extends StatefulWidget {
  const WriterRegistrationPage({super.key});

  @override
  State<WriterRegistrationPage> createState() => _WriterRegistrationPageState();
}

class _WriterRegistrationPageState extends State<WriterRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _razonController = TextEditingController();
  final TextEditingController _sitioController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();

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
              _buildTextField('Nombre comercial', _nombreController),
              const SizedBox(height: 16),
              _buildTextField('RUC', _rucController, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField('Razón social', _razonController),
              const SizedBox(height: 16),
              _buildTextField('Sitio web', _sitioController),
              const SizedBox(height: 16),
              _buildUploadButton(),
              const SizedBox(height: 16),
              _buildTextField('Ubicación de la empresa', _ubicacionController),
              const SizedBox(height: 16),
              _buildTextField('Tipo de Empresa', _tipoController),
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
                          builder: (context) => const WriterHomePage(),
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

  Widget _buildUploadButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.upload_file, color: Colors.teal),
          SizedBox(width: 10),
          Text('Logo: No hay archivo seleccionado'),
          Spacer(),
          Icon(Icons.cloud_upload_outlined, color: Colors.teal),
        ],
      ),
    );
  }
}
