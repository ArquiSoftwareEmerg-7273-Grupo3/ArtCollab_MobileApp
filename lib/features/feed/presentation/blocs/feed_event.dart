import 'package:equatable/equatable.dart';
import 'package:artcollab_mobile/features/feed/domain/entities/post.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeed extends FeedEvent {
  final int page;
  final int? authorId;
  final List<String>? tags;

  const LoadFeed({
    this.page = 0,
    this.authorId,
    this.tags,
  });

  @override
  List<Object?> get props => [page, authorId, tags];
}

class RefreshFeed extends FeedEvent {}

class CreatePost extends FeedEvent {
  final String content;
  final List<String>? tags;

  const CreatePost({
    required this.content,
    this.tags,
  });

  @override
  List<Object?> get props => [content, tags];
}

class DeletePost extends FeedEvent {
  final int postId;

  const DeletePost(this.postId);

  @override
  List<Object?> get props => [postId];
}

class AddComment extends FeedEvent {
  final int postId;
  final String content;
  final int? parentCommentId;

  const AddComment({
    required this.postId,
    required this.content,
    this.parentCommentId,
  });

  @override
  List<Object?> get props => [postId, content, parentCommentId];
}

class AddReaction extends FeedEvent {
  final int postId;
  final String reactionType;

  const AddReaction({
    required this.postId,
    required this.reactionType,
  });

  @override
  List<Object?> get props => [postId, reactionType];
}

class RemoveReaction extends FeedEvent {
  final int postId;

  const RemoveReaction(this.postId);

  @override
  List<Object?> get props => [postId];
}

class CreateRepost extends FeedEvent {
  final int postId;
  final String? comment;

  const CreateRepost({
    required this.postId,
    this.comment,
  });

  @override
  List<Object?> get props => [postId, comment];
}

class RemoveRepost extends FeedEvent {
  final int postId;

  const RemoveRepost(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ConnectRealtime extends FeedEvent {
  final String token;

  const ConnectRealtime(this.token);

  @override
  List<Object?> get props => [token];
}

class DisconnectRealtime extends FeedEvent {}

class NewPostReceived extends FeedEvent {
  final Post post;

  const NewPostReceived(this.post);

  @override
  List<Object?> get props => [post];
}

class PostDeletedReceived extends FeedEvent {
  final int postId;

  const PostDeletedReceived(this.postId);

  @override
  List<Object?> get props => [postId];
}
