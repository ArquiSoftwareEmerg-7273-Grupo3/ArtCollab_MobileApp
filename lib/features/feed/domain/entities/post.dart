class Post {
  final int id;
  final int authorId;
  final String content;
  final List<String> tags;
  final List<String> mediaUrls;
  final DateTime createdAt;
  final int viewCount;
  final int commentCount;
  final int reactionCount;
  final int repostCount;

  Post({
    required this.id,
    required this.authorId,
    required this.content,
    required this.tags,
    required this.mediaUrls,
    required this.createdAt,
    required this.viewCount,
    required this.commentCount,
    required this.reactionCount,
    required this.repostCount,
  });
}
