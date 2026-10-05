import 'package:flutter/material.dart' show RangeValues;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/car_filter_search/model/car_filter.dart';

// ---------------- APPLIED ----------------
// Car list idha paathu dhaan filter aagum
class AppliedFilterNotifier extends Notifier<CarFilter> {
  @override
  CarFilter build() {
    return const CarFilter(); // start: filter illa
  }

  void apply(CarFilter filter) {
    state = filter;
  }

  void clear() {
    state = const CarFilter();
  }
}



final appliedFilterProvider =NotifierProvider<AppliedFilterNotifier, CarFilter>( AppliedFilterNotifier.new);



// ---------------- DRAFT ----------------
// Bottom sheet idha dhaan edit pannum
class DraftFilterNotifier extends Notifier<CarFilter> {
  @override
  CarFilter build() {
    return ref.read(appliedFilterProvider); // applied oda copy
  }

  // ----- Fuel -----
  void toggleFuel(String fuel) {
    final newFuels = {...state.fuels}; // pudhu copy
    if (newFuels.contains(fuel)) {
      newFuels.remove(fuel);
    } else {
      newFuels.add(fuel);
    }
    state = state.copyWith(fuels: newFuels);
  }

  // ----- Body Type -----
  void toggleBodyType(String type) {
    final newTypes = {...state.bodyTypes};
    if (newTypes.contains(type)) {
      newTypes.remove(type);
    } else {
      newTypes.add(type);
    }
    state = state.copyWith(bodyTypes: newTypes);
  }

  // ----- Variant -----
  void toggleVariant(String variant) {
    final newVariants = {...state.variants};
    if (newVariants.contains(variant)) {
      newVariants.remove(variant);
    } else {
      newVariants.add(variant);
    }
    state = state.copyWith(variants: newVariants);
  }

  // ----- Rating (int) -----
  void toggleRating(int rating) {
    final newRatings = {...state.ratings};
    if (newRatings.contains(rating)) {
      newRatings.remove(rating);
    } else {
      newRatings.add(rating);
    }
    state = state.copyWith(ratings: newRatings);
  }

  // ----- Brand (single model) -----
  void toggleBrand(String model) {
    final newBrands = {...state.brands};
    if (newBrands.contains(model)) {
      newBrands.remove(model);
    } else {
      newBrands.add(model);
    }
    state = state.copyWith(brands: newBrands);
  }

  // ----- Brand "Select All" -----
  void toggleBrandGroup(List<String> models) {
    final newBrands = {...state.brands};

    // ellame already tick-a nu check
    bool allSelected = true;

    for (final model in models) {
      if (!newBrands.contains(model)) {
        allSelected = false;
      }
    }

    if (allSelected) {
      for (final model in models) {
        newBrands.remove(model); // ellam remove
      }
    } else {
      for (final model in models) {
        newBrands.add(model); // ellam add
      }
    }

    state = state.copyWith(brands: newBrands);
  }

  // ----- Sliders -----
  void setBudget(RangeValues range) {
    state = state.copyWith(budget: range);
  }

  void setMileage(RangeValues range) {
    state = state.copyWith(mileage: range);
  }

  void setEngineCc(RangeValues range) {
    state = state.copyWith(engineCc: range);
  }

  // ----- Clear All -----
  void clear() {
    state = const CarFilter();
  }
}

final draftFilterProvider =
NotifierProvider.autoDispose<DraftFilterNotifier, CarFilter>(
    DraftFilterNotifier.new);