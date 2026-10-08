import 'package:riverpod_learning/features/compare/models/car_model.dart';



/// Dummy repository. Replace the bodies with your API / Firestore calls,
/// the providers and UI do not need any change.
class CarRepository {
  static const _carImg = 'assets/cars/car.png';
  static const _delay = Duration(milliseconds: 250);

  static const brands = <Brand>[
    Brand(id: 'toyota', name: 'Toyota', logo: 'assets/brands/toyota.png'),
    Brand(id: 'kia', name: 'Kia', logo: 'assets/brands/kia.png'),
    Brand(id: 'honda', name: 'Honda', logo: 'assets/brands/honda.png'),
    Brand(
        id: 'suzuki',
        name: 'Suzuki',
        displayName: 'Maruti Suzuki',
        logo: 'assets/brands/suzuki.png'),
    Brand(id: 'ford', name: 'Ford', logo: 'assets/brands/ford.png'),
    Brand(id: 'mercedes', name: 'Mercedes Benz', logo: 'assets/brands/mercedes.png'),
    Brand(id: 'hyundai', name: 'Hyundai', logo: 'assets/brands/hyundai.png'),
    Brand(id: 'bmw', name: 'BMW', logo: 'assets/brands/bmw.png'),
    Brand(id: 'tata', name: 'Tata', logo: 'assets/brands/tata.png'),
    Brand(id: 'mahindra', name: 'Mahindra', logo: 'assets/brands/mahindra.png'),
    Brand(id: 'skoda', name: 'Skoda', logo: 'assets/brands/skoda.png'),
    Brand(id: 'audi', name: 'Audi', logo: 'assets/brands/audi.png'),
  ];

  static const _suzukiModels = <CarModel>[
    CarModel(id: 'wagonr', brandId: 'suzuki', name: 'Wagonar', priceRange: '3.5 - 5.25 lakh*', image: _carImg),
    CarModel(id: 'glanza', brandId: 'suzuki', name: 'Glanza', priceRange: '3.5 - 5.25 lakh*', image: _carImg),
    CarModel(id: 'altok10', brandId: 'suzuki', name: 'Alto k10', priceRange: '3.5 - 5.25 lakh*', image: _carImg),
    CarModel(id: 'altotour', brandId: 'suzuki', name: 'Alto tour H1', priceRange: '3.5 - 5.25 lakh*', image: _carImg),
    CarModel(id: 'celerio', brandId: 'suzuki', name: 'Celero', priceRange: '3.5 - 5.25 lakh*', image: _carImg),
    CarModel(id: 'wagonrtour', brandId: 'suzuki', name: 'Wagona R Tour', priceRange: '3.5 - 5.25 lakh*', image: _carImg),
  ];

  Future<List<Brand>> getBrands() async {
    await Future<void>.delayed(_delay);
    return brands;
  }

  Future<List<CarModel>> getModels(Brand brand) async {
    await Future<void>.delayed(_delay);
    if (brand.id == 'suzuki') return _suzukiModels;
    return List.generate(
      6,
          (i) => CarModel(
        id: '${brand.id}_m$i',
        brandId: brand.id,
        name: '${brand.name} Model ${i + 1}',
        priceRange: '5 - 9 lakh*',
        image: _carImg,
      ),
    );
  }

  Future<List<Variant>> getVariants(CarModel model) async {
    await Future<void>.delayed(_delay);
    const rows = [
      ('STD', 'Petrol', 'Manual'),
      ('LXi', 'Petrol', 'Automatic'),
      ('VXI', 'CNG', 'Manual'),
      ('VXI OPT AT', 'Petrol', 'Automatic'),
      ('ZXI', 'Petrol', 'Manual'),
      ('ZXI+', 'Diesel', 'Automatic'),
    ];
    return [
      for (var i = 0; i < rows.length; i++)
        Variant(
          id: '${model.id}_v$i',
          modelId: model.id,
          name: rows[i].$1,
          priceRange: '3.5 - 5.25 lakh*',
          fuel: rows[i].$2,
          transmission: rows[i].$3,
        ),
    ];
  }

  // ---- sample "Popular" / "Recent" data ----
  List<ComparePair> samplePairs() {
    final suzuki = brands.firstWhere((b) => b.id == 'suzuki');
    SelectedCar car(CarModel m, String v, String fuel, String trans) =>
        SelectedCar(
          brand: suzuki,
          model: m,
          variant: Variant(
            id: '${m.id}_$v',
            modelId: m.id,
            name: v,
            priceRange: '3.5 - 5.25 lakh*',
            fuel: fuel,
            transmission: trans,
          ),
        );

    return [
      ComparePair(car(_suzukiModels[2], 'LXi', 'Petrol', 'Automatic'),
          car(_suzukiModels[0], 'VXI', 'CNG', 'Manual')),
      ComparePair(car(_suzukiModels[1], 'STD', 'Petrol', 'Manual'),
          car(_suzukiModels[4], 'LXi', 'Petrol', 'Automatic')),
      ComparePair(car(_suzukiModels[3], 'VXI', 'CNG', 'Manual'),
          car(_suzukiModels[5], 'ZXI', 'Petrol', 'Manual')),
    ];
  }

  Future<List<ComparePair>> getPopularPairs() async {
    await Future<void>.delayed(_delay);
    return samplePairs();
  }
}