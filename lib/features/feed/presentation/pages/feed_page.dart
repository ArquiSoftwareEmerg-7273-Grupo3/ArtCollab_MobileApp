import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artcollab_mobile/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:artcollab_mobile/features/feed/presentation/blocs/feed_event.dart';
import 'package:artcollab_mobile/features/feed/presentation/blocs/feed_state.dart';
import 'package:artcollab_mobile/features/feed/presentation/pages/post_detail_page.dart';
import 'package:artcollab_mobile/core/storage/token_storage.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';
import 'package:artcollab_mobile/features/users/data/remote/user_service.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/shared/widgets/user_avatar.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';
import 'package:artcollab_mobile/shared/widgets/network_image_with_fallback.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _postController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TokenStorage _tokenStorage = TokenStorage();
  final UserStorage _userStorage = UserStorage();
  final UserService _userService = UserService();
  int _currentPage = 0;
  int? _currentUserId;
  String? _currentUsername;
  final Map<int, UserProfileDto> _usersCache = {};

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadFeed();
    _connectRealtime();
    _scrollController.addListener(_onScroll);
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

  void _loadFeed() {
    context.read<FeedBloc>().add(LoadFeed(page: _currentPage));
  }

  void _connectRealtime() async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      context.read<FeedBloc>().add(ConnectRealtime(token));
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

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<FeedBloc>().state;
      if (state is FeedLoaded && state.hasMore) {
        _currentPage++;
        context.read<FeedBloc>().add(LoadFeed(page: _currentPage));
      }
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    _scrollController.dispose();
    context.read<FeedBloc>().add(DisconnectRealtime());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.teal;
    final Color accentColor = Colors.teal.shade300;
    final Color backgroundColor = Colors.grey.shade100;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Campo para crear post
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: '¿Qué estás pensando?',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: accentColor),
                      ),
                      prefixIcon: Icon(Icons.edit_note, color: accentColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (_postController.text.isNotEmpty) {
                      context.read<FeedBloc>().add(
                            CreatePost(content: _postController.text),
                          );
                      _postController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: primaryColor,
                ),
              ],
            ),
          ),

          // Lista de publicaciones con BLoC
          Expanded(
            child: BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedLoading && _currentPage == 0) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FeedError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _currentPage = 0;
                            _loadFeed();
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is FeedLoaded) {
                  if (state.posts.isEmpty) {
                    return const Center(
                      child: Text('No hay publicaciones aún'),
                    );
                  }

                  return RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () async {
                      _currentPage = 0;
                      context.read<FeedBloc>().add(RefreshFeed());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.posts.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.posts.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final post = state.posts[index];
                        
                        // Load user profile if not in cache
                        _loadUserProfile(post.authorId);
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          elevation: 4,
                          shadowColor: primaryColor.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailPage(post: post),
                                ),
                              );
                            },
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Encabezado del usuario
                              ListTile(
                                leading: UserAvatar(
                                  photoUrl: _usersCache[post.authorId]?.foto,
                                  initials: _getUserInitials(post.authorId),
                                  radius: 20,
                                  backgroundColor: post.authorId == _currentUserId 
                                      ? primaryColor 
                                      : accentColor,
                                  textColor: Colors.white,
                                ),
                                title: Text(
                                  _getUserDisplayName(post.authorId),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  _formatTime(post.createdAt),
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert, color: accentColor),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: const Text('Eliminar'),
                                      onTap: () {
                                        context.read<FeedBloc>().add(
                                              DeletePost(post.id),
                                            );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // Imágenes del post
                              if (post.mediaUrls.isNotEmpty)
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: NetworkImageWithFallback(
                                    imageUrl: post.mediaUrls.first,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),

                              // Contenido del post
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  post.content,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),

                              // Tags
                              if (post.tags.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Wrap(
                                    spacing: 8,
                                    children: post.tags
                                        .map((tag) => Chip(
                                              label: Text('#$tag'),
                                              backgroundColor:
                                                  accentColor.withOpacity(0.2),
                                            ))
                                        .toList(),
                                  ),
                                ),

                              // Estadísticas
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('${post.viewCount}',
                                        style: TextStyle(color: Colors.grey)),
                                    const SizedBox(width: 16),
                                    Icon(Icons.favorite,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('${post.reactionCount}',
                                        style: TextStyle(color: Colors.grey)),
                                    const SizedBox(width: 16),
                                    Icon(Icons.comment,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('${post.commentCount}',
                                        style: TextStyle(color: Colors.grey)),
                                    const SizedBox(width: 16),
                                    Icon(Icons.repeat,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('${post.repostCount}',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),

                              // Botones de interacción
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        context.read<FeedBloc>().add(
                                              AddReaction(
                                                postId: post.id,
                                                reactionType: 'LIKE',
                                              ),
                                            );
                                      },
                                      icon: Icon(Icons.favorite_border,
                                          color: accentColor),
                                      label: Text('Me gusta',
                                          style: TextStyle(color: accentColor)),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        _showCommentDialog(context, post.id);
                                      },
                                      icon: Icon(Icons.comment_outlined,
                                          color: accentColor),
                                      label: Text('Comentar',
                                          style: TextStyle(color: accentColor)),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        context.read<FeedBloc>().add(
                                              CreateRepost(postId: post.id),
                                            );
                                      },
                                      icon: Icon(Icons.repeat,
                                          color: accentColor),
                                      label: Text('Repost',
                                          style: TextStyle(color: accentColor)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        );
                      },
                    ),
                  );
                }

                return const Center(child: Text('Cargando...'));
              },
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
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Ahora';
    }
  }

  void _showCommentDialog(BuildContext context, int postId) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Agregar comentario'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'Escribe tu comentario...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                context.read<FeedBloc>().add(
                      AddComment(
                        postId: postId,
                        content: commentController.text,
                      ),
                    );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Comentar'),
          ),
        ],
      ),
    );
  }
}
