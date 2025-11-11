import 'package:flutter/material.dart';
import 'applicants_page.dart';

class JobsPublishedPage extends StatefulWidget {
  const JobsPublishedPage({super.key});

  @override
  State<JobsPublishedPage> createState() => _JobsPublishedPageState();
}

class _JobsPublishedPageState extends State<JobsPublishedPage> {
  final List<Map<String, dynamic>> jobs = [
    {
      'title': 'Colaboración de creación de un cómic',
      'image': 'https://cdn-icons-png.flaticon.com/512/616/616408.png',
      'author': 'Carolina Suárez',
      'time': 'Publicado hace 4 horas',
      'applicants': [
        {'name': 'Gustavo Sandoval', 'avatar': 'https://i.pravatar.cc/150?img=1'},
        {'name': 'Valeria Romero', 'avatar': 'https://i.pravatar.cc/150?img=2'},
        {'name': 'Javier Olivera', 'avatar': 'https://i.pravatar.cc/150?img=3'},
      ],
    },
    {
      'title': 'Creación de un libro infantil ilustrado',
      'image': 'https://cdn-icons-png.flaticon.com/512/2917/2917995.png',
      'author': 'Carolina Suárez',
      'time': 'Publicado hace 4 horas',
      'applicants': [
        {'name': 'Lucía Torres', 'avatar': 'https://i.pravatar.cc/150?img=4'},
        {'name': 'Andrés Vega', 'avatar': 'https://i.pravatar.cc/150?img=5'},
        {'name': 'Marta Fernández', 'avatar': 'https://i.pravatar.cc/150?img=6'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ApplicantsPage(
                    title: job['title'],
                    applicants: job['applicants'],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      job['image'],
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.teal,
                              radius: 12,
                              child: Icon(Icons.person,
                                  color: Colors.white, size: 14),
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['author'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  job['time'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
