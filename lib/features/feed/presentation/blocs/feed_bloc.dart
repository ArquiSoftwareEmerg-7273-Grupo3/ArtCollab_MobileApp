import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artcollab_mobile/core/utils/resource.dart';
import 'package:artcollab_mobile/features/feed/data/repository/feed_repository.dart';
import 'package:artcollab_mobile/features/feed/domain/entities/post.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository _repository;

  FeedBloc({FeedRepository? repository})
      : _repository = repository ?? FeedRepository(),
        super(FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<RefreshFeed>(_onRefreshFeed);
    on<CreatePost>(_onCreatePost);
    on<DeletePost>(_onDeletePost);
    on<AddComment>(_onAddComment);
    on<AddReaction>(_onAddReaction);
    on<RemoveReaction>(_onRemoveReaction);
    on<CreateRepost>(_onCreateRepost);
    on<RemoveRepost>(_onRemoveRepost);
    on<ConnectRealtime>(_onConnectRealtime);
    on<DisconnectRealtime>(_onDisconnectRealtime);
    on<NewPostReceived>(_onNewPostReceived);
    on<PostDeletedReceived>(_onPostDeletedReceived);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    if (event.page == 0) {
      emit(FeedLoading());
    }

    final result = await _repository.getPosts(
      page: event.page,
      size: 10,
      authorId: event.authorId,
      tags: event.tags,
    );

    if (result is Success<List<Post>>) {
      final posts = result.data!;
      
      if (state is FeedLoaded && event.page > 0) {
        final currentPosts = (state as FeedLoaded).posts;
        emit(FeedLoaded(
          posts: [...currentPosts, ...posts],
          hasMore: posts.length >= 10,
          currentPage: event.page,
        ));
      } else {
        emit(FeedLoaded(
          posts: posts,
          hasMore: posts.length >= 10,
          currentPage: event.page,
        ));
      }
    } else if (result is Error) {
      emit(FeedError(result.message!));
    }
  }

  Future<void> _onRefreshFeed(RefreshFeed event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    add(const LoadFeed(page: 0));
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<FeedState> emit) async {
    emit(PostCreating());

    final result = await _repository.createPost(
      content: event.content,
      tags: event.tags,
    );

    if (result is Success<int>) {
      emit(PostCreated(result.data!));
      // Refresh feed after creating post
      add(RefreshFeed());
    } else if (result is Error) {
      emit(FeedError(result.message!));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<FeedState> emit) async {
    emit(PostDeleting());

    final result = await _repository.deletePost(event.postId);

    if (result is Success) {
      emit(PostDeleted());
      // Remove post from current state
      if (state is FeedLoaded) {
        final currentState = state as FeedLoaded;
        final updatedPosts = currentState.posts
            .where((post) => post.id != event.postId)
            .toList();
        emit(currentState.copyWith(posts: updatedPosts));
      }
    } else if (result is Error) {
      emit(FeedError(result.message!));
    }
  }

  Future<void> _onAddComment(AddComment event, Emitter<FeedState> emit) async {
    emit(CommentAdding());

    final result = await _repository.addComment(
      postId: event.postId,
      content: event.content,
      parentCommentId: event.parentCommentId,
    );

    if (result is Success<int>) {
      emit(CommentAdded(result.data!));
      // Refresh feed to update comment count
      add(RefreshFeed());
    } else if (result is Error) {
      emit(FeedError(result.message!));
    }
  }

  Future<void> _onAddReaction(AddReaction event, Emitter<FeedState> emit) async {
    emit(ReactionProcessing());

    final result = await _repository.addReaction(
      postId: event.postId,
      reactionType: event.reactionType,
    );

    if (result is Success) {
      emit(ReactionProcessed());
      // Refresh feed to update reaction count
      add(RefreshFeed());
    } else if (result is Error) {
      emit(FeedError(result.message!));
    }
  }

  Future<void> _onRemoveReaction(RemoveReaction event, Emitter<FeedState> emit) async {
    emit(ReactionProcessing());

    final result = await _repository.removeReaction(event.postId);

    if (result is Success) {
      emit(ReactionProcessed());
      // Refresh feed to update reaction count
      add(RefreshFeed());
    } else if (result is Error) {
      emit(FeedError(result.message!));
    }
  }

  Future<void> _onCreateRepost(CreateRepost event, Emitter<FeedState> emit) async {
    emit(RepostCreating());

    final result = await _repository.createRepost(
      postId: event.postId,
      comment: event.comment,
    );

    if (result is Success<int>) {
      emit(RepostCreated(result.data!));
      // Refresh feed to update repost count
      add(RefreshFeed());
    } else if (result is Error) {
      emit(FeedError(result.message!));
    }
  }

  Future<void> _onRemoveRepost(RemoveRepost event, Emitter<FeedState> emit) async {
    emit(RepostRemoving());

    final result = await _repository.removeRepost(event.postId);

    if (result is Success) {
      emit(RepostRemoved());
      // Refresh feed to update repost count
      add(RefreshFeed());
    } else if (result is Error) {
      emit(FeedError(result.message!));
    }
  }

  void _onConnectRealtime(ConnectRealtime event, Emitter<FeedState> emit) {
    _repository.connectRealtime(event.token);
    
    // Listen for new posts
    _repository.onNewPost((post) {
      add(NewPostReceived(post));
    });

    // Listen for deleted posts
    _repository.onPostDeleted((postId) {
      add(PostDeletedReceived(postId));
    });
  }

  void _onDisconnectRealtime(DisconnectRealtime event, Emitter<FeedState> emit) {
    _repository.disconnectRealtime();
  }

  void _onNewPostReceived(NewPostReceived event, Emitter<FeedState> emit) {
    if (state is FeedLoaded) {
      final currentState = state as FeedLoaded;
      final updatedPosts = [event.post, ...currentState.posts];
      emit(currentState.copyWith(posts: updatedPosts));
    }
  }

  void _onPostDeletedReceived(PostDeletedReceived event, Emitter<FeedState> emit) {
    if (state is FeedLoaded) {
      final currentState = state as FeedLoaded;
      final updatedPosts = currentState.posts
          .where((post) => post.id != event.postId)
          .toList();
      emit(currentState.copyWith(posts: updatedPosts));
    }
  }

  @override
  Future<void> close() {
    _repository.disconnectRealtime();
    return super.close();
  }
}
