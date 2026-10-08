import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/compare/models/car_model.dart';
import 'common_widgets.dart';

/// White box that turns pink + red border when selected.
class _SelectableBox extends StatelessWidget {
  const _SelectableBox({
    required this.selected,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.radius = 10,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsets padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: padding,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
              color: selected ? AppColors.primary : AppColors.border2),
        ),
        child: child,
      ),
    );
  }
}

// ============================================================
// BRAND TILE
// ============================================================

class BrandTile extends StatelessWidget {
  const BrandTile({super.key, required this.brand, required this.selected, required this.onTap});

  final Brand brand;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: Text(
        brand.name.isEmpty ? '?' : brand.name[0],
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.grey2),
      ),
    );

    return _SelectableBox(
      selected: selected,
      onTap: onTap,
      padding: const EdgeInsets.all(4),
      radius: 8,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: brand.logo == null
                      ? fallback
                      : Image.asset(brand.logo!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => fallback),
                ),
                const SizedBox(height: 4),
                Text(brand.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 9, color: AppColors.grey2)),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3)),
                child: const Icon(Icons.check, size: 10, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// MODEL CARD
// ============================================================

class ModelCard extends StatelessWidget {
  const ModelCard({super.key, required this.model, required this.selected, required this.onTap});

  final CarModel model;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SelectableBox(
      selected: selected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text)),
          const SizedBox(height: 4),
          PriceRow(price: model.priceRange, fontSize: 11),
          Expanded(
            child: Center(child: CarImage(path: model.image, height: 60)),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// VARIANT CARD
// ============================================================

class VariantCard extends StatelessWidget {
  const VariantCard({super.key, required this.variant, required this.selected, required this.onTap});

  final Variant variant;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SelectableBox(
      selected: selected,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(variant.name,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(flex: 5, child: PriceRow(price: variant.priceRange, fontSize: 11)),
              Expanded(
                  flex: 3,
                  child: IconLabel(
                      icon: Icons.local_gas_station_outlined,
                      label: variant.fuel)),
              Expanded(
                  flex: 3,
                  child: IconLabel(
                      icon: Icons.settings_outlined,
                      label: variant.transmission)),
            ],
          ),
        ],
      ),
    );
  }
}