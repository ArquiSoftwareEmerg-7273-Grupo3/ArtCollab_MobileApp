import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/chat/data/remote/chat_service.dart';
import 'package:artcollab_mobile/features/users/data/remote/user_service.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/shared/widgets/user_avatar.dart';
import 'package:artcollab_mobile/features/chat/presentation/pages/chat_detail_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatService _chatService = ChatService();
  final UserService _userService = UserService();
  final UserStorage _userStorage = UserStorage();
  
  List<ChatDto> _chats = [];
  bool _isLoading = true;
  int? _currentUserId;
  final Map<int, UserProfileDto> _usersCache = {};

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userId = await _userStorage.getUserId();
    setState(() => _currentUserId = userId);
    if (userId != null) {
      _loadChats();
    }
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);
    
    final result = await _chatService.getAllChats();
    if (result is Success<List<ChatDto>>) {
      setState(() {
        _chats = result.data ?? [];
        _isLoading = false;
      });
      
      // Cargar información de usuarios
      for (final chat in _chats) {
        _loadUserInfo(chat.usuario1id);
        _loadUserInfo(chat.usuario2id);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadUserInfo(int userId) async {
    if (_usersCache.containsKey(userId)) return;
    
    final result = await _userService.getUserById(userId);
    if (result is Success<UserProfileDto>) {
      setState(() {
        _usersCache[userId] = result.data!;
      });
    }
  }

  int _getOtherUserId(ChatDto chat) {
    return chat.usuario1id == _currentUserId 
        ? chat.usuario2id 
        : chat.usuario1id;
  }

  String _getOtherUserName(ChatDto chat) {
    final otherUserId = _getOtherUserId(chat);
    if (_usersCache.containsKey(otherUserId)) {
      return _usersCache[otherUserId]!.displayName;
    }
    return 'Usuario $otherUserId';
  }

  String _getOtherUserInitials(ChatDto chat) {
    final otherUserId = _getOtherUserId(chat);
    if (_usersCache.containsKey(otherUserId)) {
      return _usersCache[otherUserId]!.initials;
    }
    return 'U';
  }

  String? _getOtherUserPhoto(ChatDto chat) {
    final otherUserId = _getOtherUserId(chat);
    if (_usersCache.containsKey(otherUserId)) {
      return _usersCache[otherUserId]!.foto;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Mensajes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda de usuarios
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Búsqueda de usuarios próximamente'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes conversaciones',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Inicia una conversación con otros usuarios',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadChats,
                  child: ListView.builder(
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: UserAvatar(
                            photoUrl: _getOtherUserPhoto(chat),
                            initials: _getOtherUserInitials(chat),
                            radius: 24,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                          ),
                          title: Text(
                            _getOtherUserName(chat),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            chat.estado ? 'Activo' : 'Inactivo',
                            style: TextStyle(
                              color: chat.estado 
                                  ? Colors.green 
                                  : Colors.grey,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.teal,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailPage(
                                  chat: chat,
                                  otherUserName: _getOtherUserName(chat),
                                  otherUserPhoto: _getOtherUserPhoto(chat),
                                  otherUserInitials: _getOtherUserInitials(chat),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
