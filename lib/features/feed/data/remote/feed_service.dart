import 'dart:convert';
import 'dart:io';
import 'package:artcollab_mobile/core/network/api_client.dart';
import 'package:artcollab_mobile/core/network/socket_client.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/feed/data/remote/post_dto.dart';
import 'package:http/http.dart' as http;

class FeedService {
  final ApiClient _apiClient;
  final SocketClient _socketClient;

  FeedService({
    ApiClient? apiClient,
    SocketClient? socketClient,
  })  : _apiClient = apiClient ?? ApiClient(),
        _socketClient = socketClient ?? SocketClient();

  /// Get posts with pagination
  Future<Resource<List<PostDto>>> getPosts({
    int page = 0,
    int size = 10,
    int? authorId,
    List<String>? tags,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'size': size.toString(),
      };

      if (authorId != null) {
        queryParams['authorId'] = authorId.toString();
      }

      if (tags != null && tags.isNotEmpty) {
        queryParams['tags'] = tags.join(',');
      }

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final response = await _apiClient.get('posts?$queryString');

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        final content = json['content'] as List<dynamic>;
        final posts = content.map((e) => PostDto.fromJson(e)).toList();
        return Success(posts);
      }

      return Error('Failed to load posts');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Create a new post
  Future<Resource<int>> createPost({
    required String content,
    List<String>? tags,
  }) async {
    try {
      final body = {
        'content': content,
        if (tags != null) 'tags': tags,
      };

      final response = await _apiClient.post('posts', body);

      if (response.statusCode == HttpStatus.created) {
        final postId = int.parse(response.body);
        return Success(postId);
      }

      return Error('Failed to create post');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Delete a post
  Future<Resource<void>> deletePost(int postId) async {
    try {
      final response = await _apiClient.delete('posts/$postId');

      if (response.statusCode == HttpStatus.noContent) {
        return Success(null);
      }

      return Error('Failed to delete post');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Add comment to post
  Future<Resource<int>> addComment({
    required int postId,
    required String content,
    int? parentCommentId,
  }) async {
    try {
      final body = {
        'content': content,
        if (parentCommentId != null) 'parentCommentId': parentCommentId,
      };

      final response = await _apiClient.post('posts/$postId/comments', body);

      if (response.statusCode == HttpStatus.created) {
        final commentId = int.parse(response.body);
        return Success(commentId);
      }

      return Error('Failed to add comment');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Add reaction to post
  Future<Resource<void>> addReaction({
    required int postId,
    required String reactionType,
  }) async {
    try {
      final body = {'reactionType': reactionType};

      final response = await _apiClient.post('posts/$postId/reactions', body);

      if (response.statusCode == HttpStatus.created) {
        return Success(null);
      }

      return Error('Failed to add reaction');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Remove reaction from post
  Future<Resource<void>> removeReaction(int postId) async {
    try {
      final response = await _apiClient.delete('posts/$postId/reactions');

      if (response.statusCode == HttpStatus.noContent) {
        return Success(null);
      }

      return Error('Failed to remove reaction');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Create a repost
  Future<Resource<int>> createRepost({
    required int postId,
    String? comment,
  }) async {
    try {
      final body = {
        if (comment != null) 'comment': comment,
      };

      final response = await _apiClient.post('posts/$postId/reposts', body);

      if (response.statusCode == HttpStatus.created) {
        final repostId = int.parse(response.body);
        return Success(repostId);
      }

      return Error('Failed to create repost');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Remove repost
  Future<Resource<void>> removeRepost(int postId) async {
    try {
      final response = await _apiClient.delete('posts/$postId/reposts');

      if (response.statusCode == HttpStatus.noContent) {
        return Success(null);
      }

      return Error('Failed to remove repost');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get comments for a post
  Future<Resource<List<CommentDto>>> getComments({
    required int postId,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _apiClient.get('posts/$postId/comments?page=$page&size=$size');

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body);
        final content = json['content'] as List<dynamic>;
        final comments = content.map((e) => CommentDto.fromJson(e)).toList();
        return Success(comments);
      }

      return Error('Failed to load comments');
    } catch (error) {
      return Error(error.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Connect to Socket.IO for real-time updates
  void connectRealtime(String token) {
    _socketClient.connect(token);
  }

  /// Listen for new posts
  void onNewPost(Function(PostDto) callback) {
    _socketClient.on('post:created', (data) {
      final post = PostDto.fromJson(data);
      callback(post);
    });
  }

  /// Listen for post deletions
  void onPostDeleted(Function(int) callback) {
    _socketClient.on('post:deleted', (data) {
      final postId = data['postId'] as int;
      callback(postId);
    });
  }

  /// Disconnect from Socket.IO
  void disconnectRealtime() {
    _socketClient.disconnect();
  }
}
