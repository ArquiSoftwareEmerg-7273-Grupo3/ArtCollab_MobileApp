import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/feed/data/remote/feed_service.dart';
import 'package:artcollab_mobile/features/feed/data/remote/post_dto.dart';
import 'package:artcollab_mobile/features/feed/domain/entities/post.dart';

class FeedRepository {
  final FeedService _feedService;

  FeedRepository({FeedService? feedService})
      : _feedService = feedService ?? FeedService();

  Future<Resource<List<Post>>> getPosts({
    int page = 0,
    int size = 10,
    int? authorId,
    List<String>? tags,
  }) async {
    final result = await _feedService.getPosts(
      page: page,
      size: size,
      authorId: authorId,
      tags: tags,
    );

    if (result is Success) {
      final posts = result.data!.map((dto) => dto.toEntity()).toList();
      return Success(posts);
    } else {
      return Error(result.message!);
    }
  }

  Future<Resource<int>> createPost({
    required String content,
    List<String>? tags,
  }) async {
    return await _feedService.createPost(content: content, tags: tags);
  }

  Future<Resource<void>> deletePost(int postId) async {
    return await _feedService.deletePost(postId);
  }

  Future<Resource<int>> addComment({
    required int postId,
    required String content,
    int? parentCommentId,
  }) async {
    return await _feedService.addComment(
      postId: postId,
      content: content,
      parentCommentId: parentCommentId,
    );
  }

  Future<Resource<void>> addReaction({
    required int postId,
    required String reactionType,
  }) async {
    return await _feedService.addReaction(
      postId: postId,
      reactionType: reactionType,
    );
  }

  Future<Resource<void>> removeReaction(int postId) async {
    return await _feedService.removeReaction(postId);
  }

  Future<Resource<int>> createRepost({
    required int postId,
    String? comment,
  }) async {
    return await _feedService.createRepost(
      postId: postId,
      comment: comment,
    );
  }

  Future<Resource<void>> removeRepost(int postId) async {
    return await _feedService.removeRepost(postId);
  }

  Future<Resource<List<CommentDto>>> getComments({
    required int postId,
    int page = 0,
    int size = 10,
  }) async {
    final result = await _feedService.getComments(
      postId: postId,
      page: page,
      size: size,
    );

    if (result is Success) {
      return Success(result.data!);
    } else {
      return Error(result.message!);
    }
  }

  void connectRealtime(String token) {
    _feedService.connectRealtime(token);
  }

  void onNewPost(Function(Post) callback) {
    _feedService.onNewPost((dto) {
      callback(dto.toEntity());
    });
  }

  void onPostDeleted(Function(int) callback) {
    _feedService.onPostDeleted(callback);
  }

  void disconnectRealtime() {
    _feedService.disconnectRealtime();
  }
}
