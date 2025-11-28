import 'package:equatable/equatable.dart';
import 'package:artcollab_mobile/features/feed/domain/entities/post.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  final bool hasMore;
  final int currentPage;

  const FeedLoaded({
    required this.posts,
    this.hasMore = true,
    this.currentPage = 0,
  });

  @override
  List<Object?> get props => [posts, hasMore, currentPage];

  FeedLoaded copyWith({
    List<Post>? posts,
    bool? hasMore,
    int? currentPage,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object?> get props => [message];
}

class PostCreating extends FeedState {}

class PostCreated extends FeedState {
  final int postId;

  const PostCreated(this.postId);

  @override
  List<Object?> get props => [postId];
}

class PostDeleting extends FeedState {}

class PostDeleted extends FeedState {}

class CommentAdding extends FeedState {}

class CommentAdded extends FeedState {
  final int commentId;

  const CommentAdded(this.commentId);

  @override
  List<Object?> get props => [commentId];
}

class ReactionProcessing extends FeedState {}

class ReactionProcessed extends FeedState {}

class RepostCreating extends FeedState {}

class RepostCreated extends FeedState {
  final int repostId;

  const RepostCreated(this.repostId);

  @override
  List<Object?> get props => [repostId];
}

class RepostRemoving extends FeedState {}

class RepostRemoved extends FeedState {}
