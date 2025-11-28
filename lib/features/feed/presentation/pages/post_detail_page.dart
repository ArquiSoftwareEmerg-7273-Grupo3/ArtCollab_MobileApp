import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artcollab_mobile/features/feed/domain/entities/post.dart';
import 'package:artcollab_mobile/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:artcollab_mobile/features/feed/presentation/blocs/feed_event.dart';
import 'package:artcollab_mobile/features/feed/data/repository/feed_repository.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';
import 'package:artcollab_mobile/features/users/data/remote/user_service.dart';
import 'package:artcollab_mobile/shared/widgets/user_avatar.dart';
import 'package:artcollab_mobile/shared/widgets/network_image_with_fallback.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final FeedRepository _repository = FeedRepository();
  final UserStorage _userStorage = UserStorage();
  final UserService _userService = UserService();
  List<dynamic> _comments = [];
  bool _loadingComments = true;
  int? _currentUserId;
  String? _currentUsername;
  final Map<int, UserProfileDto> _usersCache = {};

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadComments();
    _loadPostAuthor();
  }

  void _loadUserInfo() async {
    final userId = await _userStorage.getUserId();
    final username = await _userStorage.getUsername();
    setState(() {
      _currentUserId = userId;
      _currentUsername = username;
    });
    
    // Load current user profile
    if (userId != null) {
      final result = await _userService.getUserById(userId);
      if (result is Success) {
        setState(() {
          _usersCache[userId] = result.data!;
        });
      }
    }
  }

  Future<void> _loadPostAuthor() async {
    if (_usersCache.containsKey(widget.post.authorId)) return;
    
    final result = await _userService.getUserById(widget.post.authorId);
    if (result is Success) {
      setState(() {
        _usersCache[widget.post.authorId] = result.data!;
      });
    }
  }

  Future<void> _loadComments() async {
    setState(() => _loadingComments = true);
    final result = await _repository.getComments(postId: widget.post.id);
    if (result is Success) {
      setState(() {
        _comments = result.data ?? [];
        _loadingComments = false;
      });
      
      // Load authors of comments
      for (final comment in _comments) {
        _loadUserProfile(comment.authorId);
      }
    } else {
      setState(() => _loadingComments = false);
    }
  }

  Future<void> _loadUserProfile(int userId) async {
    if (_usersCache.containsKey(userId)) return;
    
    final result = await _userService.getUserById(userId);
    if (result is Success) {
      setState(() {
        _usersCache[userId] = result.data!;
      });
    }
  }

  String _getUserDisplayName(int authorId) {
    if (_usersCache.containsKey(authorId)) {
      return _usersCache[authorId]!.displayName;
    }
    return '@user$authorId';
  }

  String _getUserInitials(int authorId) {
    if (_usersCache.containsKey(authorId)) {
      return _usersCache[authorId]!.initials;
    }
    return 'U';
  }

  String? _getUserPhoto(int authorId) {
    if (_usersCache.containsKey(authorId)) {
      return _usersCache[authorId]!.foto;
    }
    return null;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.teal;
    final Color accentColor = Colors.teal.shade300;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Post'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Post original
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado del post
                  ListTile(
                    leading: UserAvatar(
                      photoUrl: _getUserPhoto(widget.post.authorId),
                      initials: _getUserInitials(widget.post.authorId),
                      radius: 20,
                      backgroundColor: widget.post.authorId == _currentUserId 
                          ? primaryColor 
                          : accentColor,
                      textColor: Colors.white,
                    ),
                    title: Text(
                      _getUserDisplayName(widget.post.authorId),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_formatTime(widget.post.createdAt)),
                  ),

                  // Contenido
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.post.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  // Tags
                  if (widget.post.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 8,
                        children: widget.post.tags
                            .map((tag) => Chip(
                                  label: Text('#$tag'),
                                  backgroundColor: accentColor.withOpacity(0.2),
                                ))
                            .toList(),
                      ),
                    ),

                  // Imágenes
                  if (widget.post.mediaUrls.isNotEmpty)
                    ...widget.post.mediaUrls.map((url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NetworkImageWithFallback(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )),

                  // Estadísticas
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.favorite, size: 20, color: Colors.red),
                        const SizedBox(width: 4),
                        Text('${widget.post.reactionCount}'),
                        const SizedBox(width: 16),
                        Icon(Icons.comment, size: 20, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text('${widget.post.commentCount}'),
                        const SizedBox(width: 16),
                        Icon(Icons.repeat, size: 20, color: Colors.green),
                        const SizedBox(width: 4),
                        Text('${widget.post.repostCount}'),
                      ],
                    ),
                  ),

                  const Divider(),

                  // Sección de comentarios
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Comentarios (${_comments.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Lista de comentarios
                  if (_loadingComments)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text('No hay comentarios aún'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return ListTile(
                          leading: UserAvatar(
                            photoUrl: _getUserPhoto(comment.authorId),
                            initials: _getUserInitials(comment.authorId),
                            radius: 18,
                            backgroundColor: comment.authorId == _currentUserId 
                                ? primaryColor 
                                : accentColor,
                            textColor: Colors.white,
                          ),
                          title: Text(
                            _getUserDisplayName(comment.authorId),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(comment.content),
                          trailing: Text(
                            _formatTime(comment.createdAt),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          // Campo para agregar comentario
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un comentario...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      context.read<FeedBloc>().add(
                            AddComment(
                              postId: widget.post.id,
                              content: _commentController.text,
                            ),
                          );
                      _commentController.clear();
                      // Recargar comentarios después de un momento
                      Future.delayed(const Duration(seconds: 1), () {
                        _loadComments();
                      });
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m atrás';
    } else {
      return 'Ahora';
    }
  }
}
