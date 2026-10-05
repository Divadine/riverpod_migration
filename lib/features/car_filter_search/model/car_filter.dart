import 'package:flutter/material.dart' show RangeValues;

enum FilterSection {
  brand('Brands'),
  bodyType('Body Types'),
  budget('Budget'),
  mileage('Mileage'),
  variant('Variant'),
  engineCc('Engine CC'),
  fuel('Fuel'),
  ratings('Ratings');

  final String label;
  const FilterSection(this.label);
}

class CarFilter {
  final Set<String> brands; // selected model names, e.g. "Audi A6"
  final Set<String> bodyTypes;
  final RangeValues? budget;
  final RangeValues? mileage;
  final Set<String> variants;
  final RangeValues? engineCc;
  final Set<String> fuels;
  final Set<int> ratings;

  const CarFilter({
    this.brands = const {},
    this.bodyTypes = const {},
    this.budget,
    this.mileage,
    this.variants = const {},
    this.engineCc,
    this.fuels = const {},
    this.ratings = const {},
  });

  CarFilter copyWith({
    Set<String>? brands,
    Set<String>? bodyTypes,
    RangeValues? budget,
    RangeValues? mileage,
    Set<String>? variants,
    RangeValues? engineCc,
    Set<String>? fuels,
    Set<int>? ratings,
  }) {
    return CarFilter(
      brands: brands ?? this.brands,
      bodyTypes: bodyTypes ?? this.bodyTypes,
      budget: budget ?? this.budget,
      mileage: mileage ?? this.mileage,
      variants: variants ?? this.variants,
      engineCc: engineCc ?? this.engineCc,
      fuels: fuels ?? this.fuels,
      ratings: ratings ?? this.ratings,
    );
  }

  // Drives "Brands (1)" in the left menu
  int countFor(FilterSection s) => switch (s) {
    FilterSection.brand => brands.length,
    FilterSection.bodyType => bodyTypes.length,
    FilterSection.budget => budget == null ? 0 : 1,
    FilterSection.mileage => mileage == null ? 0 : 1,
    FilterSection.variant => variants.length,
    FilterSection.engineCc => engineCc == null ? 0 : 1,
    FilterSection.fuel => fuels.length,
    FilterSection.ratings => ratings.length,
  };

  // Drives the red badge on "Filter by"
  int get activeCount =>
      FilterSection.values.where((s) => countFor(s) > 0).length;
}