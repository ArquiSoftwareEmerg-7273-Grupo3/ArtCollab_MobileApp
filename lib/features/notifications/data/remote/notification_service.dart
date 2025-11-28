import 'dart:convert';
import 'dart:io';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// GET /api/v1/notifications?userId={userId} - Obtener todas las notificaciones de un usuario
  Future<Resource<List<NotificationDto>>> getNotifications(int userId) async {
    try {
      final response = await _apiClient.get('notifications?userId=$userId');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final notifications = json.map((e) => NotificationDto.fromJson(e)).toList();
        return Success(notifications);
      }
      return Error('Error al cargar las notificaciones');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/notifications/unread?userId={userId} - Obtener notificaciones no leídas
  Future<Resource<List<NotificationDto>>> getUnreadNotifications(int userId) async {
    try {
      final response = await _apiClient.get('notifications/unread?userId=$userId');
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> json = jsonDecode(response.body);
        final notifications = json.map((e) => NotificationDto.fromJson(e)).toList();
        return Success(notifications);
      }
      return Error('Error al cargar las notificaciones no leídas');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// GET /api/v1/notifications/{notificationId} - Obtener una notificación por ID
  Future<Resource<NotificationDto>> getNotificationById(int notificationId) async {
    try {
      final response = await _apiClient.get('notifications/$notificationId');
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(NotificationDto.fromJson(json));
      }
      return Error('Error al cargar la notificación');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PATCH /api/v1/notifications/{notificationId}/read - Marcar notificación como leída
  Future<Resource<NotificationDto>> markAsRead(int notificationId) async {
    try {
      final response = await _apiClient.patch(
        'notifications/$notificationId/read',
        {'isRead': true},
      );
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(NotificationDto.fromJson(json));
      }
      return Error('Error al marcar la notificación como leída');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// POST /api/v1/notifications/comments?postAuthorId={postAuthorId} - Crear notificación de comentario
  Future<Resource<NotificationDto>> createFromComment(
    int postAuthorId,
    int commentId,
    int actorId,
    int postId,
  ) async {
    try {
      final response = await _apiClient.post(
        'notifications/comments?postAuthorId=$postAuthorId',
        {
          'commentId': commentId,
          'actorId': actorId,
          'postId': postId,
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(NotificationDto.fromJson(json));
      }
      return Error('Error al crear la notificación de comentario');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// POST /api/v1/notifications/reactions?postAuthorId={postAuthorId} - Crear notificación de reacción
  Future<Resource<NotificationDto>> createFromReaction(
    int postAuthorId,
    int actorId,
    int postId,
  ) async {
    try {
      final response = await _apiClient.post(
        'notifications/reactions?postAuthorId=$postAuthorId',
        {
          'actorId': actorId,
          'postId': postId,
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        return Success(NotificationDto.fromJson(json));
      }
      return Error('Error al crear la notificación de reacción');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }
}

class NotificationDto {
  final int id;
  final int recipientId;
  final int? actorId;
  final int? postId;
  final int? commentId;
  final String type;
  final String sourceType;
  final String status;
  final String message;
  final bool active;
  final DateTime createdAt;
  final DateTime? readAt;

  NotificationDto({
    required this.id,
    required this.recipientId,
    this.actorId,
    this.postId,
    this.commentId,
    required this.type,
    required this.sourceType,
    required this.status,
    required this.message,
    required this.active,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'] ?? 0,
      recipientId: json['recipientId'] ?? 0,
      actorId: json['actorId'],
      postId: json['postId'],
      commentId: json['commentId'],
      type: json['type'] ?? '',
      sourceType: json['sourceType'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      active: json['active'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientId': recipientId,
      'actorId': actorId,
      'postId': postId,
      'commentId': commentId,
      'type': type,
      'sourceType': sourceType,
      'status': status,
      'message': message,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  bool get isRead => status == 'READ' || readAt != null;
}
