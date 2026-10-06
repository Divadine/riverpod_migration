import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/chips/provider/chips_provider.dart';

class BrandChip extends ConsumerWidget {
  const BrandChip({super.key, required this.brand});

  final String brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selected = ref.watch(
      brandSelectionProvider.select((set) => set.contains(brand)),
    );

    return InkWell(
      onTap: () => ref.read(brandSelectionProvider.notifier).toggle(brand),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kAccentSoft : Colors.transparent,
          border: Border.all(color: selected ? kAccent : kBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          brand,
          style: TextStyle(
            fontSize: 13,
            color: selected ? kAccent : const Color(0xFF7A7A7A),
          ),
        ),
      ),
    );
  }
}

