import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/cars/provider/car_providers.dart';
import 'package:riverpod_learning/features/cars/screen/upcoming_car_page.dart';
import 'package:riverpod_learning/features/cars/widget/car_section.dart';
import 'package:riverpod_learning/features/cars/widget/home_car_card.dart';       // new
import 'package:riverpod_learning/features/cars/widget/home_upcoming_card.dart';  // new
import 'popular_models_page.dart';

class CarHomeScreen extends ConsumerWidget {
  const CarHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Good morning',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CarSection(
                title: 'Popular Models',
                provider: popularModelsProvider,
                height: 182,
                itemBuilder: (car) => HomeCarCard(car: car), // changed
                onSeeAll: () {
                  ref.read(popularSearchProvider.notifier).update('');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PopularModelsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              CarSection(
                title: 'Upcoming Cars',
                provider: upcomingCarsProvider,
                height: 160,
                itemBuilder: (car) => HomeUpcomingCard(car: car), // changed
                onSeeAll: () {
                  ref.read(upcomingSearchProvider.notifier).update('');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UpcomingCarsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_learning/features/cars/provider/car_providers.dart';
// import 'package:riverpod_learning/features/cars/screen/upcoming_car_page.dart';
// import 'package:riverpod_learning/features/cars/widget/car_card.dart';
// import 'package:riverpod_learning/features/cars/widget/car_section.dart';
// import 'popular_models_page.dart';
//
// class CarHomeScreen extends ConsumerWidget {
//   const CarHomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Good morning',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//         ),
//         actions: [
//           IconButton(icon: const Icon(Icons.search), onPressed: () {}),
//           IconButton(
//               icon: const Icon(Icons.notifications_none), onPressed: () {}),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // TODO: Popular Brands grid inga varum
//
//               CarSection(
//                 title: 'Popular Models',
//                 provider: popularModelsProvider,
//                 onSeeAll: () {
//                   ref.read(popularSearchProvider.notifier).update('');
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const PopularModelsPage(),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 24),
//               CarSection(
//                 title: 'Upcoming Cars',
//                 provider: upcomingCarsProvider,
//                 type: CarCardType.upcoming,
//                 onSeeAll: () {
//                   ref.read(upcomingSearchProvider.notifier).update(''); // search reset
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const UpcomingCarsPage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }