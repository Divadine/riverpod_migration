import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/cars/model/car_model.dart';

class CarSection extends ConsumerWidget {
  final String title;
  final Provider<List<CarModel>> provider;
  final Widget Function(CarModel car) itemBuilder; // ← new
  final double height; // ← new
  final VoidCallback? onSeeAll;

  const CarSection({
    super.key,
    required this.title,
    required this.provider,
    required this.itemBuilder,
    this.height = 182,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cars = ref.watch(provider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: onSeeAll,
                child: const Text('See all',
                    style: TextStyle(fontSize: 12, color: AppColors.red)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: height,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: cars.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => itemBuilder(cars[i]),
          ),
        ),
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_learning/core/theme/color.dart';
// import 'package:riverpod_learning/features/cars/model/car_model.dart';
//
// import 'car_card.dart';
//
// class CarSection extends ConsumerWidget {
//   final String title;
//   final Provider<List<CarModel>> provider; // fixed
//   final CarCardType type;
//   final VoidCallback? onSeeAll;
//   final ValueChanged<CarModel>? onCarTap;
//
//   const CarSection({
//     super.key,
//     required this.title,
//     required this.provider,
//     this.type = CarCardType.compact,
//     this.onSeeAll,
//     this.onCarTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cars = ref.watch(provider);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//               GestureDetector(
//                 onTap: onSeeAll,
//                 child: const Text(
//                   'See all',
//                   style: TextStyle(fontSize: 12, color: AppColors.red),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: type == CarCardType.upcoming ? 160 : 182,//type == CarCardType.upcoming ? 150 : 190,
//           child: ListView.separated(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             scrollDirection: Axis.horizontal,
//             itemCount: cars.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 12),
//             itemBuilder: (_, i) => CarCard(
//               car: cars[i],
//               type: type,
//               onTap: onCarTap == null ? null : () => onCarTap!(cars[i]),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }