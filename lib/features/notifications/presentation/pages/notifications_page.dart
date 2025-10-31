import 'dart:math';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController searchController = TextEditingController();
  final Random _random = Random();

  final List<Map<String, dynamic>> _notificationTemplates = [
    {
      'title': 'Nuevo seguidor',
      'subtitle': '📸 {user} empezó a seguirte. ¡Bienvenido a la comunidad!',
      'icon': Icons.person_add_alt_1,
    },
    {
      'title': 'Comentario recibido',
      'subtitle': '💬 {user} comentó tu obra “{artwork}”.',
      'icon': Icons.comment,
    },
    {
      'title': 'Tu arte fue destacado',
      'subtitle': '🌟 “{artwork}” fue destacado en la sección de tendencias.',
      'icon': Icons.star,
    },
    {
      'title': 'Nuevo like',
      'subtitle': '❤️ “{artwork}” recibió {count} nuevos likes.',
      'icon': Icons.favorite,
    },
    {
      'title': 'Desafío creativo',
      'subtitle': '🎨 Participa en el reto “{challenge}” y muestra tu estilo.',
      'icon': Icons.palette,
    },
    {
      'title': 'Mensaje de colaboración',
      'subtitle': '🤝 {user} te invitó a colaborar en un nuevo proyecto.',
      'icon': Icons.mail,
    },
    {
      'title': 'Actualiza tu portafolio',
      'subtitle': '🖌️ Hace tiempo que no subes nuevas obras. ¡Inspírate hoy!',
      'icon': Icons.edit,
    },
    {
      'title': 'Tendencia cercana',
      'subtitle': '🚀 El estilo “{trend}” está ganando popularidad esta semana.',
      'icon': Icons.trending_up,
    },
    {
      'title': 'Sugerencia de artista',
      'subtitle': '🔍 Descubre el trabajo de @{user}, con un estilo similar al tuyo.',
      'icon': Icons.recommend,
    },
    {
      'title': 'Tu arte fue compartido',
      'subtitle': '📢 Tu obra “{artwork}” fue compartida por {count} usuarios.',
      'icon': Icons.share,
    },
  ];

  final List<String> _users = [
    'LauraPixels',
    'CarlosDesign',
    'AndresVisual',
    'ArtByLuna',
    'StudioGraphix',
    'MikaDraws',
    'NeoInk',
    'PixelMancer'
  ];

  final List<String> _artworks = [
    'Neon Dreams',
    'Minimal Cityscape',
    'Abstract Waves',
    'Cyber Portrait',
    'Surreal Night',
    'Glass Horizon'
  ];

  final List<String> _challenges = [
    'Colores del Futuro',
    'Minimalismo Digital',
    'CiberNaturaleza',
    'Inspiración Retro',
  ];

  final List<String> _trends = [
    'Cyberpunk',
    '3D Minimalista',
    'Pixel Art',
    'Estilo Acuarela'
  ];

  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _generateRandomNotifications();
  }

  void _generateRandomNotifications() {
    final randomList = List.generate(8, (index) {
      final template =
          _notificationTemplates[_random.nextInt(_notificationTemplates.length)];

      String subtitle = template['subtitle']
          .replaceAll('{user}', _users[_random.nextInt(_users.length)])
          .replaceAll('{artwork}', _artworks[_random.nextInt(_artworks.length)])
          .replaceAll('{challenge}', _challenges[_random.nextInt(_challenges.length)])
          .replaceAll('{trend}', _trends[_random.nextInt(_trends.length)])
          .replaceAll('{count}', (_random.nextInt(40) + 5).toString());

      return {
        'title': template['title'],
        'subtitle': subtitle,
        'icon': template['icon'],
        'time': _generateRandomTime(),
      };
    });

    setState(() {
      notifications = randomList;
    });
  }

  String _generateRandomTime() {
    final hours = _random.nextInt(23);
    final minutes = _random.nextInt(59);
    if (hours == 0) return 'Hace ${minutes + 1} min';
    if (hours < 5) return 'Hace ${hours} h';
    return 'Hoy, ${10 + _random.nextInt(8)}:${minutes.toString().padLeft(2, '0')} AM';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar notificaciones...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Lista de notificaciones generadas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Icon(item['icon'], color: Colors.teal.shade700),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      item['subtitle'],
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Text(
                      item['time'],
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Botón flotante para recargar
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateRandomNotifications,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.refresh),
        label: const Text('Recargar'),
      ),
    );
  }
}
