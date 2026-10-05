import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/cars/provider/car_providers.dart';

class CarBookmarkButton extends ConsumerWidget {
  final String carId;
  const CarBookmarkButton({super.key, required this.carId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // indha car mattum bookmark aagi irukkanu paakkum
    final saved = ref.watch(
      bookmarkProvider.select((ids) => ids.contains(carId)),
    );

    return GestureDetector(
      onTap: () => ref.read(bookmarkProvider.notifier).toggle(carId),
      child: Icon(
        saved ? Icons.bookmark : Icons.bookmark_border,
        size: 24,
        color: saved ? AppColors.red : Colors.black,
      ),
    );
  }
}