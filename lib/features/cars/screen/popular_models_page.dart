import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/cars/provider/car_providers.dart';
import 'package:riverpod_learning/features/cars/widget/car_list_card.dart'; // changed

class PopularModelsPage extends ConsumerWidget {
  const PopularModelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cars = ref.watch(filteredPopularModelsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Popular Models',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) =>
                  ref.read(popularSearchProvider.notifier).update(v),
              decoration: InputDecoration(
                hintText: 'Search by popular models',
                hintStyle:
                const TextStyle(fontSize: 13, color: AppColors.grey),
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.red),
                ),
              ),
            ),
          ),
          Expanded(
            child: cars.isEmpty
                ? const Center(child: Text('No cars found'))
                : ListView.separated(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.fromLTRB(16, 0

                  , 16, 16),
              itemCount: cars.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) =>
                  CarListCard(car: cars[i]), // changed
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_learning/core/theme/color.dart';
// import 'package:riverpod_learning/features/cars/provider/car_providers.dart';
// import 'package:riverpod_learning/features/cars/widget/car_card.dart';
//
// class PopularModelsPage extends ConsumerWidget {
//   const PopularModelsPage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cars = ref.watch(filteredPopularModelsProvider);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Popular Models',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: TextField(
//               onChanged: (v) =>
//                   ref.read(popularSearchProvider.notifier).update(v),
//               decoration: InputDecoration(
//                 hintText: 'Search by popular models',
//                 hintStyle:
//                 const TextStyle(fontSize: 13, color: AppColors.grey),
//                 prefixIcon: const Icon(Icons.search, size: 20),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: EdgeInsets.zero,
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.border),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.red),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: cars.isEmpty
//                 ? const Center(child: Text('No cars found'))
//                 : ListView.separated(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               itemCount: cars.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (_, i) =>
//                   CarCard(car: cars[i], type: CarCardType.detailed),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }