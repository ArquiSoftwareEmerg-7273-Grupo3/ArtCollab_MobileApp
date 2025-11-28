import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/notifications/data/remote/notification_service.dart';
import 'package:artcollab_mobile/core/storage/user_storage.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();
  final UserStorage _userStorage = UserStorage();
  
  List<NotificationDto> _notifications = [];
  bool _isLoading = true;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userId = await _userStorage.getUserId();
    setState(() => _currentUserId = userId);
    if (userId != null) {
      _loadNotifications();
    }
  }

  Future<void> _loadNotifications() async {
    if (_currentUserId == null) return;
    
    setState(() => _isLoading = true);
    
    final result = await _notificationService.getNotifications(_currentUserId!);
    if (result is Success<List<NotificationDto>>) {
      setState(() {
        _notifications = result.data ?? [];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead(NotificationDto notification) async {
    if (notification.isRead) return;
    
    final result = await _notificationService.markAsRead(notification.id);
    if (result is Success) {
      _loadNotifications();
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toUpperCase()) {
      case 'COMMENT':
        return Icons.comment;
      case 'REACTION':
      case 'LIKE':
        return Icons.favorite;
      case 'FOLLOW':
        return Icons.person_add;
      case 'MESSAGE':
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type.toUpperCase()) {
      case 'COMMENT':
        return Colors.blue;
      case 'REACTION':
      case 'LIKE':
        return Colors.red;
      case 'FOLLOW':
        return Colors.green;
      case 'MESSAGE':
        return Colors.purple;
      default:
        return Colors.grey;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes notificaciones',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Te notificaremos cuando haya actividad',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        color: notification.isRead 
                            ? Colors.white 
                            : Colors.teal.shade50,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getNotificationColor(notification.type)
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getNotificationIcon(notification.type),
                              color: _getNotificationColor(notification.type),
                              size: 24,
                            ),
                          ),
                          title: Text(
                            notification.message,
                            style: TextStyle(
                              fontWeight: notification.isRead 
                                  ? FontWeight.normal 
                                  : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(notification.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              if (!notification.isRead)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Nueva',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          trailing: !notification.isRead
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.teal,
                                  ),
                                  onPressed: () => _markAsRead(notification),
                                  tooltip: 'Marcar como leída',
                                )
                              : null,
                          onTap: () {
                            _markAsRead(notification);
                            // TODO: Navegar al contenido relacionado
                            if (notification.postId != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Navegación a post próximamente'),
                                  backgroundColor: Colors.teal,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
