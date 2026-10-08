import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/features/compare/providers/compare_provider.dart';
import '../widgets/selection_bottom_bar.dart';
import '../widgets/selection_cards.dart';
import '../widgets/step_indicator.dart';

/// One screen, three steps (Brand -> Model -> Variant), driven by
/// [selectionProvider]. Opened from a slot on the home screen.
class SelectCarScreen extends ConsumerWidget {
  const SelectCarScreen({super.key, required this.slotIndex});

  final int slotIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sel = ref.watch(selectionProvider);
    final notifier = ref.read(selectionProvider.notifier);

    void onNext() {
      if (sel.step < 2) {
        notifier.next();
        return;
      }
      final car = notifier.result;
      if (car == null) return;
      ref.read(compareSlotsProvider.notifier).setSlot(slotIndex, car);
      Navigator.of(context).pop();
    }

    // System back = previous step; on step 1 it leaves the screen.
    return PopScope(
      canPop: sel.step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) notifier.back();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => sel.step == 0
                ? Navigator.of(context).pop()
                : notifier.back(),
          ),
          title: Text(
            sel.step == 0 ? 'Select Brand' : 'Select model',
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: AppColors.text),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: AppColors.border),
          ),
        ),
        body: Column(
          children: [
            StepIndicator(currentStep: sel.step),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: switch (sel.step) {
                0 => const _BrandStep(),
                1 => const _ModelStep(),
                _ => const _VariantStep(),
              },
            ),
            SelectionBottomBar(
              showBack: sel.step > 0,
              canNext: sel.canNext,
              onBack: notifier.back,
              onNext: onNext,
            ),
          ],
        ),
      ),
    );
  }
}

const _loader =
Center(child: CircularProgressIndicator(color: AppColors.primary));

// ============================================================
// STEP 1 : BRAND
// ============================================================

class _BrandStep extends ConsumerWidget {
  const _BrandStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brands = ref.watch(brandsProvider);
    final selected = ref.watch(selectionProvider.select((s) => s.brand));

    return brands.when(
      loading: () => _loader,
      error: (e, _) => const Center(child: Text('Unable to load brands')),
      data: (list) => GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.92,
        ),
        itemBuilder: (_, i) => BrandTile(
          brand: list[i],
          selected: selected?.id == list[i].id,
          onTap: () => ref.read(selectionProvider.notifier).selectBrand(list[i]),
        ),
      ),
    );
  }
}

// ============================================================
// STEP 2 : MODEL
// ============================================================

class _ModelStep extends ConsumerWidget {
  const _ModelStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sel = ref.watch(selectionProvider);
    final query = ref.watch(modelSearchProvider).trim().toLowerCase();
    final models = ref.watch(modelsProvider);

    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sel.brand?.title ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text)),
              const SizedBox(height: 2),
              const Text('Select by model continue to next step',
                  style: TextStyle(fontSize: 12, color: AppColors.grey)),
              const SizedBox(height: 12),
              TextField(
                onChanged: (v) =>
                ref.read(modelSearchProvider.notifier).state = v,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search by models',
                  hintStyle:
                  const TextStyle(fontSize: 12, color: AppColors.grey),
                  prefixIcon: const Icon(Icons.search,
                      size: 18, color: AppColors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: border(AppColors.border),
                  focusedBorder: border(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: models.when(
            loading: () => _loader,
            error: (e, _) => const Center(child: Text('Unable to load models')),
            data: (all) {
              final list = query.isEmpty
                  ? all
                  : all
                  .where((m) => m.name.toLowerCase().contains(query))
                  .toList();
              if (list.isEmpty) {
                return const Center(child: Text('No models found'));
              }
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.02,
                ),
                itemBuilder: (_, i) => ModelCard(
                  model: list[i],
                  selected: sel.model?.id == list[i].id,
                  onTap: () =>
                      ref.read(selectionProvider.notifier).selectModel(list[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// STEP 3 : VARIANT
// ============================================================

class _VariantStep extends ConsumerWidget {
  const _VariantStep();

  static const _transmissions = ['All', 'Automatic', 'Manual'];
  static const _fuels = ['All', 'Petrol', 'CNG', 'Diesel'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sel = ref.watch(selectionProvider);
    final notifier = ref.read(selectionProvider.notifier);
    final variants = ref.watch(filteredVariantsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              for (final t in _transmissions) ...[
                _RadioLabel(
                  label: t,
                  selected: sel.transmission == t,
                  onTap: () => notifier.setTransmission(t),
                ),
                const SizedBox(width: 12),
              ],
              const Spacer(),
              Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: sel.fuel,
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    style: const TextStyle(fontSize: 12, color: AppColors.text),
                    items: [
                      for (final f in _fuels)
                        DropdownMenuItem(
                          value: f,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_gas_station_outlined,
                                  size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(f),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (v) {
                      if (v != null) notifier.setFuel(v);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: variants.when(
            loading: () => _loader,
            error: (e, _) =>
            const Center(child: Text('Unable to load variants')),
            data: (list) {
              if (list.isEmpty) {
                return const Center(child: Text('No variants found'));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => VariantCard(
                  variant: list[i],
                  selected: sel.variant?.id == list[i].id,
                  onTap: () => notifier.selectVariant(list[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RadioLabel extends StatelessWidget {
  const _RadioLabel({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            size: 18,
            color: selected ? AppColors.primary : AppColors.grey2,
          ),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: selected ? AppColors.text : AppColors.grey2)),
        ],
      ),
    );
  }
}