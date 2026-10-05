class ReelVideo {
  final int id;
  final String videoUrl;
  final String profileImage;
  final String username;
  final String description;

  final int likes;
  final int comments;

  final bool isLiked;
  final bool isBookmarked;
  final bool isFollowing;

  ReelVideo({required this.id, required this.videoUrl, required this.profileImage, required this.username, required this.description, required this.likes, required this.comments, required this.isLiked, required this.isBookmarked, required this.isFollowing});

  ReelVideo copyWith({
    int? id,
    String? videoUrl,
    String? profileImage,
    String? username,
    String? description,
    int? likes,
    int? comments,
    bool? isLiked,
    bool? isBookmarked,
    bool? isFollowing,

  }) {
    return ReelVideo(
        id: id ?? this.id,
        videoUrl: videoUrl ?? this.videoUrl,
        profileImage: profileImage ?? this.profileImage,
        username:  username ?? this.username,
        description:  description ?? this.description,
        likes: likes ?? this.likes,
        comments:comments ?? this.comments,
        isLiked: isLiked ?? this.isLiked,
        isBookmarked: isBookmarked ?? this.isBookmarked,
        isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}