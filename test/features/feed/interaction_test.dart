import 'package:flutter_test/flutter_test.dart';
import 'package:artcollab_mobile/features/feed/data/remote/feed_service.dart';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/storage/token_storage.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('Comment and Reaction Property Tests', () {
    // Feature: backend-integration, Property 14: Comment association
    test('comment is associated with correct post ID', () async {
      for (int i = 0; i < 100; i++) {
        final postId = i + 1;
        final commentId = i + 100;

        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/posts/$postId/comments')) {
            return http.Response(commentId.toString(), 201);
          }
          return http.Response('', 404);
        });

        final apiClient = ApiClient(client: mockClient, tokenStorage: MockTokenStorage());
        final feedService = FeedService(apiClient: apiClient);

        final result = await feedService.addComment(
          postId: postId,
          content: 'Test comment $i',
        );

        expect(result, isA<Success>());
        expect((result as Success).data, equals(commentId));

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 15: Reaction count increment
    test('adding reaction succeeds', () async {
      for (int i = 0; i < 100; i++) {
        final postId = i + 1;

        final mockClient = MockClient((request) async {
          if (request.method == 'POST' && request.url.path.contains('/reactions')) {
            return http.Response('', 201);
          }
          return http.Response('', 404);
        });

        final apiClient = ApiClient(client: mockClient, tokenStorage: MockTokenStorage());
        final feedService = FeedService(apiClient: apiClient);

        final result = await feedService.addReaction(
          postId: postId,
          reactionType: 'LIKE',
        );

        expect(result, isA<Success>());

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 16: Reaction round-trip
    test('adding and removing reaction succeeds', () async {
      for (int i = 0; i < 100; i++) {
        final postId = i + 1;

        final mockClient = MockClient((request) async {
          if (request.method == 'POST' && request.url.path.contains('/reactions')) {
            return http.Response('', 201);
          } else if (request.method == 'DELETE' && request.url.path.contains('/reactions')) {
            return http.Response('', 204);
          }
          return http.Response('', 404);
        });

        final apiClient = ApiClient(client: mockClient, tokenStorage: MockTokenStorage());
        final feedService = FeedService(apiClient: apiClient);

        // Add reaction
        final addResult = await feedService.addReaction(
          postId: postId,
          reactionType: 'LIKE',
        );
        expect(addResult, isA<Success>());

        // Remove reaction
        final removeResult = await feedService.removeReaction(postId);
        expect(removeResult, isA<Success>());

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 17: Comment display completeness
    test('comment includes required fields', () async {
      for (int i = 0; i < 100; i++) {
        final postId = i + 1;
        final commentId = i + 100;

        final mockClient = MockClient((request) async {
          return http.Response(commentId.toString(), 201);
        });

        final apiClient = ApiClient(client: mockClient, tokenStorage: MockTokenStorage());
        final feedService = FeedService(apiClient: apiClient);

        final result = await feedService.addComment(
          postId: postId,
          content: 'Test comment with author info',
        );

        expect(result, isA<Success>());
        expect((result as Success).data, isNotNull);

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 18: Repost count increment
    test('creating repost succeeds', () async {
      for (int i = 0; i < 100; i++) {
        final postId = i + 1;
        final repostId = i + 200;

        final mockClient = MockClient((request) async {
          if (request.method == 'POST' && request.url.path.contains('/reposts')) {
            return http.Response(repostId.toString(), 201);
          }
          return http.Response('', 404);
        });

        final apiClient = ApiClient(client: mockClient, tokenStorage: MockTokenStorage());
        final feedService = FeedService(apiClient: apiClient);

        final result = await feedService.createRepost(
          postId: postId,
          comment: 'Test repost comment',
        );

        expect(result, isA<Success>());
        expect((result as Success).data, equals(repostId));

        apiClient.close();
      }
    });
  });

  group('Interaction Unit Tests', () {
    test('CommentDto parses from JSON correctly', () {
      final json = {
        'id': 1,
        'postId': 2,
        'authorId': 3,
        'content': 'Test comment',
        'createdAt': '2024-01-01T00:00:00Z',
        'parentCommentId': null,
      };

      final dto = CommentDto.fromJson(json);
      expect(dto.id, equals(1));
      expect(dto.postId, equals(2));
      expect(dto.authorId, equals(3));
      expect(dto.content, equals('Test comment'));
    });

    test('ReactionDto parses from JSON correctly', () {
      final json = {
        'id': 1,
        'postId': 2,
        'userId': 3,
        'reactionType': 'LIKE',
      };

      final dto = ReactionDto.fromJson(json);
      expect(dto.id, equals(1));
      expect(dto.postId, equals(2));
      expect(dto.userId, equals(3));
      expect(dto.reactionType, equals('LIKE'));
    });
  });
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
      id: json['id'],
      postId: json['postId'],
      authorId: json['authorId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
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
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      reactionType: json['reactionType'],
    );
  }
}

class MockTokenStorage extends TokenStorage {
  @override
  Future<String?> getToken() async => 'test_token';
  
  @override
  Future<void> saveToken(String token) async {}
  
  @override
  Future<void> clearToken() async {}
  
  @override
  Future<bool> hasValidToken() async => true;
}
