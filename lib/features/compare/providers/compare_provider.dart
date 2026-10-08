import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_learning/features/compare/models/car_model.dart';

import '../data/car_data.dart';

// ============================================================
// REPOSITORY
// ============================================================

final carRepositoryProvider = Provider<CarRepository>((ref) => CarRepository());

// ============================================================
// HOME : compare slots (max 3)
// ============================================================

class CompareSlotsNotifier extends Notifier<List<SelectedCar?>> {
  static const maxSlots = 3;

  @override
  List<SelectedCar?> build() => List<SelectedCar?>.filled(maxSlots, null);

  void setSlot(int index, SelectedCar car) {
    final list = [...state];
    list[index] = car;
    state = list;
  }

  void clearSlot(int index) {
    final list = [...state];
    list[index] = null;
    state = list;
  }
}

final compareSlotsProvider =
NotifierProvider<CompareSlotsNotifier, List<SelectedCar?>>(
    CompareSlotsNotifier.new);

/// Compare button is enabled when at least 2 cars are selected.
final canCompareProvider = Provider<bool>((ref) {
  return ref.watch(compareSlotsProvider).whereType<SelectedCar>().length >= 2;
});

// ============================================================
// HOME : popular & recent
// ============================================================

final popularCompareProvider = FutureProvider<List<ComparePair>>((ref) {
  return ref.read(carRepositoryProvider).getPopularPairs();
});

class RecentCompareNotifier extends Notifier<List<ComparePair>> {
  @override
  List<ComparePair> build() => ref.read(carRepositoryProvider).samplePairs();

  void add(ComparePair pair) => state = [pair, ...state];
}

final recentCompareProvider =
NotifierProvider<RecentCompareNotifier, List<ComparePair>>(
    RecentCompareNotifier.new);

// ============================================================
// SELECTION FLOW : Brand -> Model -> Variant
// ============================================================

class SelectionState {
  final int step; // 0 = brand, 1 = model, 2 = variant
  final Brand? brand;
  final CarModel? model;
  final Variant? variant;
  final String transmission; // All / Automatic / Manual
  final String fuel; // All / Petrol / CNG / Diesel

  const SelectionState({
    this.step = 0,
    this.brand,
    this.model,
    this.variant,
    this.transmission = 'All',
    this.fuel = 'All',
  });

  bool get canNext {
    switch (step) {
      case 0:
        return brand != null;
      case 1:
        return model != null;
      default:
        return variant != null;
    }
  }

  SelectionState copyWith({
    int? step,
    Variant? variant,
    String? transmission,
    String? fuel,
  }) =>
      SelectionState(
        step: step ?? this.step,
        brand: brand,
        model: model,
        variant: variant ?? this.variant,
        transmission: transmission ?? this.transmission,
        fuel: fuel ?? this.fuel,
      );
}

class SelectionNotifier extends Notifier<SelectionState> {
  @override
  SelectionState build() => const SelectionState();

  // Changing brand clears model + variant. Changing model clears variant.
  void selectBrand(Brand b) =>
      state = SelectionState(step: state.step, brand: b);

  void selectModel(CarModel m) =>
      state = SelectionState(step: state.step, brand: state.brand, model: m);

  void selectVariant(Variant v) => state = state.copyWith(variant: v);

  void setTransmission(String t) => state = state.copyWith(transmission: t);
  void setFuel(String f) => state = state.copyWith(fuel: f);

  void next() {
    if (state.canNext && state.step < 2) {
      state = state.copyWith(step: state.step + 1);
    }
  }

  void back() {
    if (state.step > 0) state = state.copyWith(step: state.step - 1);
  }

  SelectedCar? get result {
    final s = state;
    if (s.brand == null || s.model == null || s.variant == null) return null;
    return SelectedCar(brand: s.brand!, model: s.model!, variant: s.variant!);
  }
}

/// autoDispose => selection resets every time the select screen is closed.
final selectionProvider =
NotifierProvider.autoDispose<SelectionNotifier, SelectionState>(
    SelectionNotifier.new);

// ---- data for each step ----

final brandsProvider = FutureProvider<List<Brand>>((ref) {
  return ref.read(carRepositoryProvider).getBrands();
});

final modelsProvider = FutureProvider.autoDispose<List<CarModel>>((ref) {
  final brand = ref.watch(selectionProvider.select((s) => s.brand));
  if (brand == null) return <CarModel>[];
  return ref.read(carRepositoryProvider).getModels(brand);
});

final variantsProvider = FutureProvider.autoDispose<List<Variant>>((ref) {
  final model = ref.watch(selectionProvider.select((s) => s.model));
  if (model == null) return <Variant>[];
  return ref.read(carRepositoryProvider).getVariants(model);
});

final modelSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final filteredVariantsProvider =
Provider.autoDispose<AsyncValue<List<Variant>>>((ref) {
  final trans = ref.watch(selectionProvider.select((s) => s.transmission));
  final fuel = ref.watch(selectionProvider.select((s) => s.fuel));
  return ref.watch(variantsProvider).whenData(
        (list) => list
        .where((v) =>
    (trans == 'All' || v.transmission == trans) &&
        (fuel == 'All' || v.fuel == fuel))
        .toList(),
  );
});