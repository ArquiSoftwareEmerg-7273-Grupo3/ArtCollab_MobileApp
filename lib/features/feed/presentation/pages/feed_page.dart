import 'package:flutter/material.dart';
import 'dart:math';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> posts = [];

  @override
  void initState() {
    super.initState();
    _generatePosts();
  }

  void _generatePosts() {
    final random = Random();
    final newPosts = List.generate(6, (index) {
      final user = [
        'Carlos',
        'Lucía',
        'Pedro',
        'María',
        'Jorge',
        'Ana'
      ][random.nextInt(6)];
      final content = [
        'Explorando nuevas ideas para mi libro 🚀',
        'La práctica hace al maestro #Blessed #HustleHard',
        '¡Qué día tan productivo! Amo el arte!!!!',
        'Me gusta usar ArtCollab, así podré encontrar chamba xd',
        'Disfrutando del fin de semana con amigos ☕ #Vibe #Ocio',
        'Creando diseños para mi nuevo libro #Etesech'
      ][random.nextInt(6)];
      final imageUrl =
          'https://picsum.photos/seed/${random.nextInt(200)}/600/400';
      return {
        'user': user,
        'content': content,
        'time': '${random.nextInt(59) + 1} min atrás',
        'image': imageUrl,
      };
    });

    setState(() => posts = newPosts);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.teal;
    final Color accentColor = Colors.teal.shade300;
    final Color backgroundColor = Colors.grey.shade100;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Campo para publicar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: '¿Qué estás pensando?',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: accentColor.withOpacity(0.4)),
                ),
                prefixIcon: Icon(Icons.edit_note, color: accentColor),
              ),
            ),
          ),

          // Lista de publicaciones
          Expanded(
            child: posts.isEmpty
                ? const Center(
                    child: Text('No hay publicaciones aún'),
                  )
                : RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () async => _generatePosts(),
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          elevation: 4,
                          shadowColor: primaryColor.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Encabezado del usuario
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Text(
                                    post['user']![0],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  post['user']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(post['time']!,
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                                trailing: IconButton(
                                  icon:
                                      Icon(Icons.more_vert, color: accentColor),
                                  onPressed: () {},
                                ),
                              ),

                              // Imagen del post
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  post['image']!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                          child: Icon(Icons.broken_image)),
                                ),
                              ),

                              // Contenido del post
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  post['content']!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),

                              // Botones de interacción
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.favorite_border,
                                          color: accentColor),
                                      label: Text('Me gusta',
                                          style: TextStyle(color: accentColor)),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.comment_outlined,
                                          color: accentColor),
                                      label: Text('Comentar',
                                          style: TextStyle(color: accentColor)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
