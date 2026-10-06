import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



const kAccent = Color(0xFFE63946);
const kAccentSoft = Color(0xFFFDE8EA);
const kBorder = Color(0xFFDCDCDC);
const kMuted = Color(0xFF6B6B6B);
const kBrandLimit = 5;

const Map<String, List<String>> kBrandGroups = {
  'Popular Market Brands': [
    'Maruti Suzuki', 'Hyundai', 'Tata', 'Volkswagen', 'Mahindra',
    'Kia India', 'Honda', 'Skoda', 'Renault', 'Nissan', 'Toyota',
  ],
  'Premium & Luxury Brands': [
    'Mercedes-Benz', 'BMW', 'Audi', 'Jaguar', 'Volvo', 'Porsche',
    'Lamborghini', 'Bentley', 'Ferrari', 'Rolls-Royce',
  ],
  'Electric Vehicle Brands': ['Tesla', 'MG Motor', 'BYD', 'Citroen'],
};



class BrandSelectionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String brand) {
    if (state.contains(brand)) {
      // Always create a NEW set so Riverpod detects the change.
      state = {...state}..remove(brand);
    } else if (state.length < kBrandLimit) {
      state = {...state, brand};
    }
  }
}

final brandSelectionProvider =NotifierProvider<BrandSelectionNotifier, Set<String>>(BrandSelectionNotifier.new,);




/// Next button is enabled only when exactly 5 brands are selected.
final canContinueProvider = Provider<bool>((ref) => ref.watch(brandSelectionProvider).length == kBrandLimit,);


