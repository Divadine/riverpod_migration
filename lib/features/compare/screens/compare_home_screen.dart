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

  /// Share of the free height given to the slot row (design: 140 vs 123+123).
  static const double _slotShare = 0.363;

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
    final textScale =
    MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.3).toDouble();

    // 16 left padding, 6px gap between cards, ~10px of the 3rd card peeks in
    const hPad = 16.0;
    const gap = 6.0;
    const peek = 10.0;
    final slotWidth = (width - hPad - peek - 2 * gap) / 2;
    final pairWidth = width * _pairWidthFactor;

    // fixed vertical spacing (all the SizedBoxes + button) + 3 section titles
    const spacing = 14 + 10 + 12 + 40 + 14 + 10 + 14 + 10 + 14; // = 138
    final fixed = spacing + 3 * 20 * textScale;

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
              // split the free height between slot row and the 2 pair rows
              final free = box.maxHeight - fixed;
              final slotHeight =
              (free * _slotShare).clamp(120.0, slotWidth * 1.2).toDouble();
              final pairHeight = ((free - slotHeight) / 2)
                  .clamp(150.0, pairWidth * 0.62)
                  .toDouble();

              return Stack(
                children: [
                  // scrolls only if the screen is too small to fit everything
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),

                        // ------------ COMPARE CARS ------------
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Compare cars',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.text)),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: slotHeight,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding:
                            const EdgeInsets.symmetric(horizontal: hPad),
                            clipBehavior: Clip.none,
                            itemCount: slots.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(width: gap),
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
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                          child: SizedBox(
                            width: double.infinity,
                            height: 40,
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
                        SectionHeader(
                            title: 'Popular Compare', onSeeAll: () {}),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 14),
                        SectionHeader(
                            title: 'Recent Compare', onSeeAll: () {}),
                        const SizedBox(height: 10),
                        _PairList(
                            pairs: recent,
                            cardWidth: pairWidth,
                            height: pairHeight),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),

                  // soft shadow under the pinned header
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 8,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x14000000), Color(0x00000000)],
                          ),
                        ),
                      ),
                    ),
                  ),
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