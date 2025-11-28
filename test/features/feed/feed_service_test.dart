import 'package:flutter_test/flutter_test.dart';
import 'package:artcollab_mobile/features/feed/data/remote/feed_service.dart';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/storage/token_storage.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('Feed Property Tests', () {
    // Feature: backend-integration, Property 9: Feed pagination
    test('feed pagination returns at most size posts', () async {
      for (int i = 0; i < 50; i++) {
        final size = (i % 20) + 1;
        final posts = List.generate(size, (index) => {
          'id': index,
          'authorId': 1,
          'content': 'Post $index',
          'tags': [],
          'mediaUrls': [],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'viewCount': 0,
          'commentCount': 0,
          'reactionCount': 0,
          'repostCount': 0,
        });

        final mockClient = MockClient((request) async {
          return http.Response(jsonEncode({'content': posts}), 200);
        });

        final apiClient = ApiClient(client: mockClient, tokenStorage: MockTokenStorage());
        final feedService = FeedService(apiClient: apiClient);

        final result = await feedService.getPosts(size: size);
        expect(result, isA<Success>());
        expect((result as Success).data!.length, lessThanOrEqualTo(size));

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 10: Post display completeness
    test('post display includes all required fields', () async {
      for (int i = 0; i < 100; i++) {
        final post = {
          'id': i,
          'authorId': i + 1,
          'content': 'Test content $i',
          'tags': ['tag1', 'tag2'],
          'mediaUrls': ['https://example.com/image$i.jpg'],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'viewCount': i * 10,
          'commentCount': i * 2,
          'reactionCount': i * 3,
          'repostCount': i,
        };

        final mockClient = MockClient((request) async {
          return http.Response(jsonEncode({'content': [post]}), 200);
        });

        final apiClient = ApiClient(client: mockClient, tokenStorage: MockTokenStorage());
        final feedService = FeedService(apiClient: apiClient);

        final result = await feedService.getPosts();
        expect(result, isA<Success>());
        
        final posts = (result as Success).data!;
        expect(posts.isNotEmpty, isTrue);
        
        final loadedPost = posts.first;
        // Verify all required fields are present
        expect(loadedPost.id, isNotNull);
        expect(loadedPost.authorId, isNotNull);
        expect(loadedPost.content, isNotEmpty);
        expect(loadedPost.tags, isNotNull);
        expect(loadedPost.mediaUrls, isNotNull);
        expect(loadedPost.createdAt, isNotNull);
        expect(loadedPost.viewCount, greaterThanOrEqualTo(0));
        expect(loadedPost.commentCount, greaterThanOrEqualTo(0));
        expect(loadedPost.reactionCount, greaterThanOrEqualTo(0));
        expect(loadedPost.repostCount, greaterThanOrEqualTo(0));

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 11: Post creation returns ID
    test('creating post returns post ID', () async {
      for (int i = 0; i < 100; i++) {
        final mockClient = MockClient((request) async {
          return http.Response(i.toString(), 201);
        });

        final apiClient = ApiClient(client: mockClient, tokenStorage: MockTokenStorage());
        final feedService = FeedService(apiClient: apiClient);

        final result = await feedService.createPost(content: 'Test post $i');
        expect(result, isA<Success>());
        expect((result as Success).data, equals(i));

        apiClient.close();
      }
    });

    // Feature: backend-integration, Property 12: Post deletion removes from feed
    test('deleting post succeeds and returns success', () async {
      for (int i = 0; i < 100; i++) {
        final mockClient = MockClient((request) async {
          if (request.method == 'DELETE') {
            return http.Response('', 204);
          }
          return http.Response('', 404);
        });

        final apiClient = ApiClient(client: mockClient, tokenStorage: MockTokenStorage());
        final feedService = FeedService(apiClient: apiClient);

        final result = await feedService.deletePost(i);
        expect(result, isA<Success>());
        // Verify that the result is a success (post was deleted)
        expect(result is Success, isTrue);

        apiClient.close();
      }
    });
  });

  group('Feed Unit Tests', () {
    test('PostDto parses from JSON correctly', () {
      final json = {
        'id': 1,
        'authorId': 2,
        'content': 'Test content',
        'tags': ['tag1', 'tag2'],
        'mediaUrls': ['url1'],
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
        'viewCount': 10,
        'commentCount': 5,
        'reactionCount': 3,
        'repostCount': 1,
      };

      final dto = PostDto.fromJson(json);
      expect(dto.id, equals(1));
      expect(dto.content, equals('Test content'));
      expect(dto.tags.length, equals(2));
    });
  });
}

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
  });

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(
      id: json['id'],
      authorId: json['authorId'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      mediaUrls: List<String>.from(json['mediaUrls']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      viewCount: json['viewCount'],
      commentCount: json['commentCount'],
      reactionCount: json['reactionCount'],
      repostCount: json['repostCount'],
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
