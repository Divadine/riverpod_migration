import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/reels/models/reel_video.dart';



final reelsProvider = AsyncNotifierProvider<ReelsNotifier,List<ReelVideo>>(ReelsNotifier.new);

class ReelsNotifier  extends AsyncNotifier<List<ReelVideo>>{

  @override
  Future<List<ReelVideo>> build() async{
    return _loadVideos();
  }

  Future<List<ReelVideo>> _loadVideos() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      //1
      ReelVideo(
        id: 1,
        videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        profileImage:
        'https://i.pravatar.cc/150?img=1',
        username: 'dinesh',
        description:
        'This is my first reel 🎥 #flutter #dart #reels',
        likes: 120,
        comments: 24,
        isLiked: false,
        isBookmarked: false,
        isFollowing: false,
      ),
      //2
      ReelVideo(
        id: 2,
        videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        profileImage:
        'https://i.pravatar.cc/150?img=2',
        username: 'flutter_dev',
        description:
        'Building beautiful Flutter applications 🚀',
        likes: 250,
        comments: 42,
        isLiked: true,
        isBookmarked: false,
        isFollowing: true,
      ),

      //3
      ReelVideo(
        id: 3,
        videoUrl:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        profileImage:
        'https://i.pravatar.cc/150?img=3',
        username: 'developer',
        description:
        'Keep learning and keep building 💻',
        likes: 87,
        comments: 15,
        isLiked: false,
        isBookmarked: true,
        isFollowing: false,
      ),
    ];
  }

  //like
  void toggleLike(int videoId)  {
    final currentList = state.value;

    if (currentList == null) {
      return;
    }
    state = AsyncData(currentList.map((video) {
      if(video.id != videoId){
        return video;
      }
      final newLikedState = !video.isLiked;

      return video.copyWith(isLiked: newLikedState,likes: newLikedState ? video.likes + 1 : video.likes > 0 ? video.likes - 1 : 0);
    }).toList());

  }

  //bookmark

  void toggleBookmark(int videoId) {
    final currentList = state.value;
    if (currentList == null) {
      return;
    }

    state = AsyncData(currentList.map((video) {
      if(video.id != videoId){
        return video;
      }

      return video.copyWith(isBookmarked: !video.isBookmarked,);
    }).toList());

  }

  //follow
  void toggleFollow(int videoId) {
    final currentList = state.value;

    if (currentList == null) {
      return;
    }

    state = AsyncData(
      currentList.map((video) {
        if (video.id != videoId) {
          return video;
        }

        return video.copyWith(
          isFollowing: !video.isFollowing,
        );
      }).toList(),
    );
  }

  //refresh

Future<void> refreshVideo() async{
  state = const AsyncLoading();
  try {
    final result = await _loadVideos();

    state = AsyncData(result);
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
  }
}

}