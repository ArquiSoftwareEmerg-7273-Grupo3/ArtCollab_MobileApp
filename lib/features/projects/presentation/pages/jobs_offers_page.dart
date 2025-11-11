import 'package:artcollab_mobile/features/projects/presentation/pages/job_detail_page.dart';
import 'package:flutter/material.dart';

class JobsOffersPage extends StatefulWidget {
  const JobsOffersPage({super.key});

  @override
  State<JobsOffersPage> createState() => _JobsOffersPageState();
}

class _JobsOffersPageState extends State<JobsOffersPage> {
  String? selectedCategory1;
  String? selectedCategory2;

  final List<Map<String, dynamic>> jobs = [
    {
      'title': 'Colaboración de creación de un cómic',
      'author': 'Carolina Suárez',
      'category': 'Infantil',
      'location': 'Lima',
      'mode': 'Presencial',
      'technique': 'Pintura digital',
      'image':
          'https://img.freepik.com/free-vector/comic-book-background-with-halftone-elements_23-2148835816.jpg',
      'time': 'Publicado hace 4 horas',
      'description':
          'Buscamos un colaborador para crear un cómic infantil de estilo colorido y expresivo. Ideal para artistas interesados en narrativa visual y personajes dinámicos.'
    },
    {
      'title': 'Creación de un libro infantil ilustrado',
      'author': 'Carolina Suárez',
      'category': 'Infantil',
      'location': 'Cusco',
      'mode': 'Remoto',
      'technique': 'Acuarela',
      'image':
          'https://img.freepik.com/free-vector/kid-reading-book-concept_23-2148515204.jpg',
      'time': 'Publicado hace 1 día',
      'description':
          'Se busca ilustrador para colaborar en un libro infantil con temática educativa. Ideal para quienes disfrutan de los colores suaves y composiciones cálidas.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown de categorías
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedCategory1,
                    decoration: InputDecoration(
                      labelText: 'Categoría*',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: ['Infantil', 'Digital', 'Literario', 'Ilustración']
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory1 = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedCategory2,
                    decoration: InputDecoration(
                      labelText: 'Categoría*',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: ['Presencial', 'Remoto']
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory2 = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lista de ofertas
            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailPage(job: job),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.teal[100],
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              job['image'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['title'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        size: 18, color: Colors.black54),
                                    const SizedBox(width: 4),
                                    Text(
                                      job['author'],
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  job['time'],
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

