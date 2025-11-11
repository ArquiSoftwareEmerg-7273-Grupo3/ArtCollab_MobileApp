import 'package:flutter/material.dart';

class ApplicantsPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> applicants;

  const ApplicantsPage({
    super.key,
    required this.title,
    required this.applicants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Postulantes a "$title"',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          final applicant = applicants[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(applicant['avatar']),
              ),
              title: Text(
                applicant['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.teal, size: 18),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Abriendo perfil de ${applicant['name']}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
