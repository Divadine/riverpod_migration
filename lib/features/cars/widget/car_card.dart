
import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/cars/model/car_model.dart';

class CarCardHeader extends StatelessWidget {
  final CarModel car;
  final Widget? trailing; // rating / bookmark / null
  final Color subtitleColor;

  const CarCardHeader({
    super.key,
    required this.car,
    this.trailing,
    this.subtitleColor = AppColors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                car.brand,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                car.name,
                style: TextStyle(fontSize: 12, color: subtitleColor),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:riverpod_learning/core/theme/color.dart';
// import 'package:riverpod_learning/features/cars/model/car_model.dart';
//
// import 'car_bookmark_button.dart';
// import 'car_info_item.dart';
// import 'car_rating_chip.dart';
//
// /// compact          -> home page horizontal card (4 values)
// /// upcoming         -> home page "Upcoming Cars" card (date only)
// /// detailed         -> Popular Models list page (6 values, full width)
// /// upcomingDetailed -> Upcoming Cars list page (date + bookmark, full width)
// enum CarCardType { compact, upcoming, detailed, upcomingDetailed }
//
// class CarCard extends StatelessWidget {
//   final CarModel car;
//   final CarCardType type;
//   final VoidCallback? onTap;
//
//   const CarCard({
//     super.key,
//     required this.car,
//     this.type = CarCardType.compact,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // full width card ah? (See all pages)
//     final isFull =
//         type == CarCardType.detailed || type == CarCardType.upcomingDetailed;
//
//     // home horizontal card: 2nd card paadhi theriya
//     // 28 = 16 (left padding) + 12 (gap between cards)
//     final screenWidth = MediaQuery.of(context).size.width;
//     final compactWidth = (screenWidth - 28) / 1.5;
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: isFull ? double.infinity : compactWidth,
//         padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: AppColors.border),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x0F000000),
//               blurRadius: 8,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _header(isFull),
//             const SizedBox(height: 6),
//             Center(
//               child: Image.asset(
//                 car.image,
//                 height: isFull ? 130 : 62,
//                 fit: BoxFit.contain,
//                 errorBuilder: (_, __, ___) =>
//                     Icon(Icons.directions_car, size: isFull ? 100 : 50),
//               ),
//             ),
//             const SizedBox(height: 8),
//             _footer(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------- HEADER: title + subtitle + (rating | bookmark) ----------------
//   Widget _header(bool isFull) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 car.brand,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 car.name,
//                 style: TextStyle(
//                   fontSize: 12,
//                   // full width cards la grey, home cards la red
//                   color: isFull ? AppColors.grey : AppColors.red,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         _trailing(),
//         // upcomingDetailed la bookmark, mathadhula rating chip
//         // type == CarCardType.upcomingDetailed
//         //     ? CarBookmarkButton(carId: car.id)
//         //     : CarRatingChip(rating: car.rating),
//       ],
//     );
//   }
//
//   // top-right corner la enna kaattanum
//   Widget _trailing() {
//     switch (type) {
//       case CarCardType.upcomingDetailed:
//         return CarBookmarkButton(carId: car.id); // See all upcoming: bookmark
//
//       case CarCardType.upcoming:
//         return const SizedBox.shrink(); // Home upcoming: onnum vendaam
//
//       case CarCardType.compact:
//       case CarCardType.detailed:
//         return CarRatingChip(rating: car.rating); // Popular cars: rating
//     }
//   }
//   // ---------------- FOOTER: bottom values ----------------
//   Widget _footer() {
//     switch (type) {
//     // ---- date mattum ----
//       case CarCardType.upcoming:
//       case CarCardType.upcomingDetailed:
//         return CarInfoItem(
//           icon: Icons.calendar_month_outlined,
//           text: car.launchDate ?? '',
//         );
//
//     // ---- 4 values (home) ----
//       case CarCardType.compact:
//         return Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: CarInfoItem(
//                     icon: Icons.currency_rupee,
//                     text: car.price,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 SizedBox(
//                   width: 80,
//                   child: CarInfoItem(
//                     icon: Icons.local_gas_station_outlined,
//                     text: car.fuel,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Row(
//               children: [
//                 Expanded(
//                   child: CarInfoItem(icon: Icons.speed, text: car.km),
//                 ),
//                 const SizedBox(width: 8),
//                 SizedBox(
//                   width: 80,
//                   child: CarInfoItem(
//                     icon: Icons.person_outline,
//                     text: car.seats,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//
//     // ---- 6 values (See all) ----
//       case CarCardType.detailed:
//         return Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: 7,
//                   child: CarInfoItem(
//                     icon: Icons.currency_rupee,
//                     text: car.price,
//                   ),
//                 ),
//                 Expanded(
//                   flex: 7,
//                   child: CarInfoItem(
//                     icon: Icons.local_gas_station_outlined,
//                     text: car.fuel,
//                   ),
//                 ),
//                 Expanded(
//                   flex: 4,
//                   child: CarInfoItem(
//                     icon: Icons.thumb_up_alt_outlined,
//                     text: car.cc ?? '',
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 7,
//                   child: CarInfoItem(icon: Icons.speed, text: car.km),
//                 ),
//                 Expanded(
//                   flex: 7,
//                   child: CarInfoItem(
//                     icon: Icons.person_outline,
//                     text: car.seats,
//                   ),
//                 ),
//                 Expanded(
//                   flex: 4,
//                   child: CarInfoItem(
//                     icon: Icons.settings_outlined,
//                     text: car.gear ?? '',
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//     }
//   }
// }