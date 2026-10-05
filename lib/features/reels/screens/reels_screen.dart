import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/reels_notifier.dart';
import '../widgets/reel_video_item.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({
    super.key,
  });

  @override
  ConsumerState<ReelsScreen> createState() =>
      _ReelsScreenState();
}

class _ReelsScreenState
    extends ConsumerState<ReelsScreen> {

  late final PageController _pageController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController =
        PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  // ==========================================================
  // PAGE CHANGED
  // ==========================================================

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final reelsState =
    ref.watch(reelsProvider);

    return Scaffold(
      backgroundColor: Colors.black,

      body: reelsState.when(
        // ====================================================
        // LOADING
        // ====================================================

        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        },

        // ====================================================
        // ERROR
        // ====================================================

        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 45,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(
                      reelsProvider,
                    );
                  },
                  child: const Text(
                    'Retry',
                  ),
                ),
              ],
            ),
          );
        },

        // ====================================================
        // DATA
        // ====================================================

        data: (videos) {
          if (videos.isEmpty) {
            return const Center(
              child: Text(
                'No videos available',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          return PageView.builder(
            controller: _pageController,

            scrollDirection:
            Axis.vertical,

            itemCount: videos.length,

            onPageChanged:
            _onPageChanged,

            itemBuilder:
                (context, index) {

              final video =
              videos[index];

              return ReelVideoItem(
                key: ValueKey(
                  video.id,
                ),
                video: video,
                isActive:
                index == _currentIndex,
                notifier:
                ref.read(
                  reelsProvider.notifier,
                ),
              );
            },
          );
        },
      ),
    );
  }
}