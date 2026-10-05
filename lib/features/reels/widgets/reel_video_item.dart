import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/reel_video.dart';
import '../providers/reels_notifier.dart';
import 'reel_action_button.dart';
import 'reel_progress_bar.dart';

class ReelVideoItem extends StatefulWidget {
  final ReelVideo video;
  final bool isActive;
  final ReelsNotifier notifier;

  const ReelVideoItem({
    super.key,
    required this.video,
    required this.isActive,
    required this.notifier,
  });

  @override
  State<ReelVideoItem> createState() =>
      _ReelVideoItemState();
}

class _ReelVideoItemState
    extends State<ReelVideoItem> {

  VideoPlayerController? _controller;

  bool _isLoading = true;
  bool _hasError = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    _initializeVideo();
  }

  @override
  void didUpdateWidget(
      covariant ReelVideoItem oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    // -------------------------------------------------------
    // Video changed
    // -------------------------------------------------------

    if (oldWidget.video.videoUrl !=
        widget.video.videoUrl) {
      _disposeController();
      _initializeVideo();

      return;
    }

    // -------------------------------------------------------
    // Active state changed
    // -------------------------------------------------------

    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _playVideo();
      } else {
        _pauseVideo();
      }
    }
  }

  Future<void> _initializeVideo() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final controller =
    VideoPlayerController.networkUrl(
      Uri.parse(widget.video.videoUrl),
    );

    _controller = controller;

    try {
      await controller.initialize();

      await controller.setLooping(true);

      await controller.setVolume(
        _isMuted ? 0 : 1,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      if (widget.isActive) {
        await controller.play();
      }
    } catch (e) {
      debugPrint(
        'Video initialization error: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  // ==========================================================
  // PLAY
  // ==========================================================

  Future<void> _playVideo() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    await controller.play();
  }

  // ==========================================================
  // PAUSE
  // ==========================================================

  Future<void> _pauseVideo() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    await controller.pause();
  }

  // ==========================================================
  // PLAY / PAUSE
  // ==========================================================

  Future<void> _togglePlayPause() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }

    if (mounted) {
      setState(() {});
    }
  }

  // ==========================================================
  // MUTE
  // ==========================================================

  Future<void> _toggleMute() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    setState(() {
      _isMuted = !_isMuted;
    });

    await controller.setVolume(
      _isMuted ? 0 : 1,
    );
  }

  // ==========================================================
  // SEEK
  // ==========================================================

  Future<void> _seekVideo(
      double progress,
      ) async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    final duration =
        controller.value.duration;

    final position = Duration(
      milliseconds:
      (duration.inMilliseconds * progress)
          .round(),
    );

    await controller.seekTo(position);
  }

  // ==========================================================
  // FORMAT TIME
  // ==========================================================

  String _formatDuration(
      Duration duration,
      ) {
    final minutes = duration.inMinutes;

    final seconds =
        duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // ==========================================================
  // SHARE
  // ==========================================================

  void _shareVideo() {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Share clicked',
        ),
      ),
    );

    // Later:
    //
    // Share.share(widget.video.videoUrl);
  }

  // ==========================================================
  // COMMENTS
  // ==========================================================

  void _openComments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Text(
              'Comments',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    if (_isLoading ||
        controller == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    if (_hasError) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 40,
              ),
              SizedBox(height: 12),
              Text(
                'Unable to play video',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!controller.value.isInitialized) {
      return const ColoredBox(
        color: Colors.black,
      );
    }

    final videoValue =
        controller.value;

    final duration =
        videoValue.duration;

    final position =
        videoValue.position;

    double progress = 0;

    if (duration.inMilliseconds > 0) {
      progress =
          position.inMilliseconds /
              duration.inMilliseconds;
    }

    progress =
        progress.clamp(0.0, 1.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: _togglePlayPause,

      child: Stack(
        fit: StackFit.expand,
        children: [

          // ==================================================
          // VIDEO
          // ==================================================

          ColoredBox(
            color: Colors.black,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: videoValue.size.width,
                height: videoValue.size.height,
                child: VideoPlayer(
                  controller,
                ),
              ),
            ),
          ),

          // ==================================================
          // GRADIENT
          // ==================================================

          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(
                      alpha: 0.15,
                    ),
                    Colors.transparent,
                    Colors.black.withValues(
                      alpha: 0.75,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ==================================================
          // PAUSE ICON
          // ==================================================

          if (!videoValue.isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 80,
              ),
            ),

          // ==================================================
          // TOP
          // ==================================================

          Positioned(
            top:
            MediaQuery.of(context)
                .padding
                .top +
                10,
            left: 16,
            right: 16,
            child: Row(
              children: [

                const Text(
                  'Reels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const Spacer(),

                IconButton(
                  onPressed: _toggleMute,
                  icon: Icon(
                    _isMuted
                        ? Icons.volume_off
                        : Icons.volume_up,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // RIGHT ACTIONS
          // ==================================================

          Positioned(
            right: 12,
            bottom: 105,
            child: Column(
              children: [

                // LIKE
                ReelActionButton(
                  icon: widget.video.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label:
                  '${widget.video.likes}',
                  color:
                  widget.video.isLiked
                      ? Colors.red
                      : Colors.white,
                  onTap: () {
                    widget.notifier.toggleLike(
                      widget.video.id,
                    );
                  },
                ),

                const SizedBox(height: 18),

                // COMMENTS
                ReelActionButton(
                  icon: Icons.comment_outlined,
                  label:
                  '${widget.video.comments}',
                  onTap: _openComments,
                ),

                const SizedBox(height: 18),

                // SHARE
                ReelActionButton(
                  icon: Icons.send_outlined,
                  label: 'Share',
                  onTap: _shareVideo,
                ),

                const SizedBox(height: 18),

                // BOOKMARK
                ReelActionButton(
                  icon: widget.video.isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  label: 'Save',
                  onTap: () {
                    widget.notifier
                        .toggleBookmark(
                      widget.video.id,
                    );
                  },
                ),
              ],
            ),
          ),

          // ==================================================
          // DESCRIPTION
          // ==================================================

          Positioned(
            left: 16,
            right: 80,
            bottom: 53,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: widget.video.profileImage.isNotEmpty
                          ? NetworkImage(widget.video.profileImage)
                          : null,
                      child: widget.video.profileImage.isEmpty
                          ? const Icon(
                        Icons.person,
                        color: Colors.white,
                      )
                          : null,
                    ),

                    const SizedBox(width: 10),
                    Text(
                      '@${widget.video.username}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Follow button
                    GestureDetector(
                      onTap: () {
                        // follow logic later
                      },
                      child: Container(
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 3),
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  widget.video.description,
                  maxLines: 3,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // PROGRESS
          // ==================================================

          Positioned(
            left: 12,
            right: 12,
            bottom: 20,
            child: Row(
              children: [

                Text(
                  _formatDuration(position),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ReelProgressBar(
                    progress: progress,
                    onChanged: _seekVideo,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  _formatDuration(duration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}