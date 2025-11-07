import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': '¡Hola! ¿Cómo estás?', 'isMe': false},
    {'text': 'Muy bien, ¿y tú?', 'isMe': true},
  ];

  final List<Map<String, String>> _recentChats = [
    {'name': 'Ana García', 'lastMessage': 'Nos vemos mañana 👋'},
    {'name': 'Carlos López', 'lastMessage': 'Te paso el link ahora...'},
    {'name': 'María Torres', 'lastMessage': '¡Qué buena idea!'},
    {'name': 'Proyecto ArtCollab', 'lastMessage': 'Subí los nuevos bocetos 🎨'},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': _messageController.text.trim(), 'isMe': true});
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Abrir chats recientes',
          ),
        ),
      ),

      // Drawer con lista de chats recientes
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: themeColor),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    //backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Chats recientes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _recentChats.length,
                itemBuilder: (context, index) {
                  final chat = _recentChats[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal[200],
                      child: Text(
                        chat['name']![0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      chat['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      chat['lastMessage']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Abriendo chat con ${chat['name']}...'),
                          backgroundColor: themeColor,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Cuerpo principal (pantalla de chat actual)
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message['isMe'] as bool;
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? themeColor.withValues()
                            : Colors.teal.shade100,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft:
                              isMe ? const Radius.circular(16) : Radius.zero,
                          bottomRight:
                              isMe ? Radius.zero : const Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: themeColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
