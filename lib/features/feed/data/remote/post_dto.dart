import 'package:artcollab_mobile/features/feed/domain/entities/post.dart';

class PostDto {
  final int id;
  final int authorId;
  final String content;
  final List<String> tags;
  final List<String> mediaUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int viewCount;
  final int commentCount;
  final int reactionCount;
  final int repostCount;
  final bool hasMedia;
  final bool active;

  PostDto({
    required this.id,
    required this.authorId,
    required this.content,
    required this.tags,
    required this.mediaUrls,
    required this.createdAt,
    required this.updatedAt,
    required this.viewCount,
    required this.commentCount,
    required this.reactionCount,
    required this.repostCount,
    this.hasMedia = false,
    this.active = true,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) {
    // Parse tags - puede venir como List o Set
    List<String> parsedTags = [];
    if (json['tags'] != null) {
      if (json['tags'] is List) {
        parsedTags = (json['tags'] as List<dynamic>).map((e) => e.toString()).toList();
      } else if (json['tags'] is Set) {
        parsedTags = (json['tags'] as Set<dynamic>).map((e) => e.toString()).toList();
      }
    }

    return PostDto(
      id: json['id'] ?? 0,
      authorId: json['authorId'] ?? 0,
      content: json['content'] ?? '',
      tags: parsedTags,
      mediaUrls: (json['mediaUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      viewCount: json['viewsCount'] ?? json['viewCount'] ?? 0,
      commentCount: json['commentsCount'] ?? json['commentCount'] ?? 0,
      reactionCount: json['reactionsCount'] ?? json['reactionCount'] ?? 0,
      repostCount: json['repostsCount'] ?? json['repostCount'] ?? 0,
      hasMedia: json['hasMedia'] ?? false,
      active: json['active'] ?? true,
    );
  }

  Post toEntity() {
    return Post(
      id: id,
      authorId: authorId,
      content: content,
      tags: tags,
      mediaUrls: mediaUrls,
      createdAt: createdAt,
      viewCount: viewCount,
      commentCount: commentCount,
      reactionCount: reactionCount,
      repostCount: repostCount,
    );
  }
}

class CommentDto {
  final int id;
  final int postId;
  final int authorId;
  final String content;
  final DateTime createdAt;
  final int? parentCommentId;

  CommentDto({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.parentCommentId,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      id: json['id'] ?? 0,
      postId: json['postId'] ?? 0,
      authorId: json['authorId'] ?? 0,
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      parentCommentId: json['parentCommentId'],
    );
  }
}

class ReactionDto {
  final int id;
  final int postId;
  final int userId;
  final String reactionType;

  ReactionDto({
    required this.id,
    required this.postId,
    required this.userId,
    required this.reactionType,
  });

  factory ReactionDto.fromJson(Map<String, dynamic> json) {
    return ReactionDto(
      id: json['id'] ?? 0,
      postId: json['postId'] ?? 0,
      userId: json['userId'] ?? 0,
      reactionType: json['reactionType'] ?? 'LIKE',
    );
  }
}

class MediaDto {
  final int id;
  final String url;
  final String originalFilename;
  final String mediaType;
  final int fileSize;

  MediaDto({
    required this.id,
    required this.url,
    required this.originalFilename,
    required this.mediaType,
    required this.fileSize,
  });

  factory MediaDto.fromJson(Map<String, dynamic> json) {
    return MediaDto(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      originalFilename: json['originalFilename'] ?? '',
      mediaType: json['mediaType'] ?? 'IMAGE',
      fileSize: json['fileSize'] ?? 0,
    );
  }
}
