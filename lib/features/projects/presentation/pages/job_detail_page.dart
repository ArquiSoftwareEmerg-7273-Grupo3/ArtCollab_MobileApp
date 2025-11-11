import 'package:flutter/material.dart';


class JobDetailPage extends StatelessWidget {
  final Map<String, dynamic> job;
  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job['title'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title'],
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  job['author'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Has postulado a "${job['title']}". ¡Éxito!'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Postular'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailText('Categoría', job['category']),
                      _buildDetailText('Ubicación', job['location']),
                      _buildDetailText('Modalidad', job['mode']),
                      _buildDetailText('Técnica', job['technique']),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(job['image']),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              job['description'],
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
