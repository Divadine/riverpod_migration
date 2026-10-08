import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/compare/models/car_model.dart';
import 'package:riverpod_learning/features/compare/providers/compare_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/compare_pair_card.dart';
import '../widgets/compare_slot_card.dart';
import '../widgets/home_header.dart';
import 'select_car_screen.dart';

class CompareHomeScreen extends ConsumerWidget {
  const CompareHomeScreen({super.key});

  /// Popular / Recent card width as a fraction of the screen width.
  static const double _pairWidthFactor = 0.82;

  void _openSelect(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SelectCarScreen(slotIndex: index)),
    );
  }

  void _compare(BuildContext context, WidgetRef ref) {
    final cars =
    ref.read(compareSlotsProvider).whereType<SelectedCar>().toList();
    if (cars.length < 2) return;

    ref
        .read(recentCompareProvider.notifier)
        .add(ComparePair(cars[0], cars[1]));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comparing ${cars.length} cars...')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = ref.watch(compareSlotsProvider);
    final canCompare = ref.watch(canCompareProvider);
    final popular = ref.watch(popularCompareProvider);
    final recent = ref.watch(recentCompareProvider);

    final width = MediaQuery.sizeOf(context).width;

    // 16 left padding, 6px gap between cards, ~10px of the 3rd card peeks in
    const hPad = 16.0;
    const gap = 6.0;
    const peek = 10.0;
    final slotWidth = (width - hPad - peek - 2 * gap) / 2;
    final pairWidth = width * _pairWidthFactor;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // ---------------- HEADER (pinned, white, covers status bar) -----
          const ColoredBox(
            color: Colors.white,
            child: SafeArea(bottom: false, child: HomeHeader()),
          ),

          Expanded(
            child: LayoutBuilder(builder: (context, box) {
              // Sum of all fixed spacing, text title heights, and button height (~175px)
              const fixedSpacing = 175.0;
              final free = (box.maxHeight - fixedSpacing).clamp(150.0, 1000.0);
              final slotHeight = (free * 0.32).clamp(90.0, 150.0);
              final pairHeight = ((free - slotHeight) / 2).clamp(90.0, 160.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // ------------ COMPARE CARS ------------
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Compare cars',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text)),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: slotHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: hPad),
                      clipBehavior: Clip.none,
                      itemCount: slots.length,
                      separatorBuilder: (_, __) => const SizedBox(width: gap),
                      itemBuilder: (context, i) {
                        return SizedBox(
                          width: slotWidth,
                          child: CompareSlotCard(
                            car: slots[i],
                            showLeadingVs: i > 0,
                            hasTrailingVs: i < slots.length - 1,
                            onTap: () => _openSelect(context, i),
                            onRemove: () => ref
                                .read(compareSlotsProvider.notifier)
                                .clearSlot(i),
                          ),
                        );
                      },
                    ),
                  ),

                  // ------------ COMPARE BUTTON ------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: canCompare
                            ? () => _compare(context, ref)
                            : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.disabled,
                          disabledForegroundColor: AppColors.grey2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Compare',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),

                  // ------------ POPULAR ------------
                  SectionHeader(title: 'Popular Compare', onSeeAll: () {}),
                  const SizedBox(height: 8),
                  popular.when(
                    data: (list) => _PairList(
                        pairs: list,
                        cardWidth: pairWidth,
                        height: pairHeight),
                    loading: () => SizedBox(
                      height: pairHeight,
                      child: const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary)),
                    ),
                    error: (e, _) => SizedBox(
                        height: pairHeight,
                        child:
                        const Center(child: Text('Unable to load'))),
                  ),

                  // ------------ RECENT ------------
                  const SizedBox(height: 10),
                  SectionHeader(title: 'Recent Compare', onSeeAll: () {}),
                  const SizedBox(height: 8),
                  _PairList(
                      pairs: recent,
                      cardWidth: pairWidth,
                      height: pairHeight),
                  const SizedBox(height: 8),
                ],
              );
            }),
          ),
        ],
      ),

      // ---------------- BOTTOM NAV ----------------
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border2, width: 1)),
          boxShadow: [
            BoxShadow(
                color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: const [
                Expanded(
                    child: _NavItem(
                        icon: Icons.smart_display_outlined, label: 'Feeds')),
                Expanded(
                    child: _NavItem(
                        icon: Icons.directions_car_outlined, label: 'Cars')),
                Expanded(
                    child: _NavItem(
                        icon: Icons.add, label: 'Post', isCenter: true)),
                Expanded(
                    child: _NavItem(
                        icon: Icons.swap_horiz,
                        label: 'Compare',
                        isSelected: true)),
                Expanded(
                    child: _NavItem(
                        icon: Icons.person_outline, label: 'Profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.isCenter = false,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    final active = isSelected || isCenter;
    final color = active ? AppColors.primary : AppColors.grey2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isCenter)
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          )
        else
          Icon(icon, size: 24, color: color),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _PairList extends StatelessWidget {
  const _PairList(
      {required this.pairs, required this.cardWidth, required this.height});

  final List<ComparePair> pairs;
  final double cardWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: pairs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) =>
            ComparePairCard(pair: pairs[i], width: cardWidth),
      ),
    );
  }
}