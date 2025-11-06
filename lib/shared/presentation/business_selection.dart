import 'package:artcollab_mobile/shared/presentation/artist_home_page.dart';
import 'package:artcollab_mobile/shared/presentation/writer_home_page.dart';
import 'package:flutter/material.dart';

class BusinessSelection extends StatefulWidget {
  const BusinessSelection({super.key});

  @override
  State<BusinessSelection> createState() => _BusinessSelectionState();
}

class _BusinessSelectionState extends State<BusinessSelection> {
  @override
  Widget build(BuildContext context) {
    //final TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Campo de búsqueda
          /*
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar opciones...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
              ),
            ),
          ),
          */

          // Menú de opciones
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildMenuButton(
                  icon: Icons.person_add_alt_1,
                  title: 'Crear perfil como escritor',
                  subtitle: 'Crea proyectos colaborativos y revisa las solicitudes de empleo',
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WriterHomePage(),
                        ),
                      );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.person_add_alt_1,
                  title: 'Crear perfil como artista',
                  subtitle: 'Configura tu perfil profesional y destaca tus obras',
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArtistHomePage(),
                        ),
                      );
                  },
                ),
                _buildMenuButton(
                  icon: Icons.analytics_outlined,
                  title: 'Análisis del Perfil',
                  subtitle: 'Obtén estadísticas y métricas sobre tu desempeño',
                  onTap: () {
                    // Acción al pulsar
                  },
                ),
                _buildMenuButton(
                  icon: Icons.star_outline,
                  title: 'Planes',
                  subtitle: 'Explora planes premium y beneficios adicionales',
                  onTap: () {
                    // Acción al pulsar
                  },
                ),
                _buildMenuButton(
                  icon: Icons.campaign_outlined,
                  title: 'Publicidad',
                  subtitle: 'Promociona tu perfil o tus publicaciones',
                  onTap: () {
                    // Acción al pulsar
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.teal.withValues(),
                child: Icon(icon, color: Colors.teal, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
