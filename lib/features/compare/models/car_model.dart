class Brand {
  final String id;
  final String name;
  final String? displayName;
  final String? logo; // asset path (optional)

  const Brand({
    required this.id,
    required this.name,
    this.displayName,
    this.logo,
  });

  String get title => displayName ?? name;
}

class CarModel {
  final String id;
  final String brandId;
  final String name;
  final String priceRange;
  final String? image; // asset path (optional)

  const CarModel({
    required this.id,
    required this.brandId,
    required this.name,
    required this.priceRange,
    this.image,
  });
}

class Variant {
  final String id;
  final String modelId;
  final String name;
  final String priceRange;
  final String fuel; // Petrol / CNG / Diesel
  final String transmission; // Manual / Automatic

  const Variant({
    required this.id,
    required this.modelId,
    required this.name,
    required this.priceRange,
    required this.fuel,
    required this.transmission,
  });
}

/// Final result of Brand -> Model -> Variant selection.
class SelectedCar {
  final Brand brand;
  final CarModel model;
  final Variant variant;

  const SelectedCar({
    required this.brand,
    required this.model,
    required this.variant,
  });

  String get title => brand.title;
  String get subtitle => '${model.name}  ${variant.name}';
  String get price => variant.priceRange;
  String? get image => model.image;
}

class ComparePair {
  final SelectedCar first;
  final SelectedCar second;
  const ComparePair(this.first, this.second);
}