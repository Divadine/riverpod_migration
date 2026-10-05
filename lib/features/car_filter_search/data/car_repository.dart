import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/car_filter_search/model/car.dart';
import 'package:riverpod_learning/features/car_filter_search/model/car_filter.dart';

class CarRepository {
  static const _all = [
    Car(id: '1', name: 'Maruti Suzuki Wagon R', brand: 'Maruti', model: 'Wagon R',
        bodyType: 'Van', variant: 'Manual', fuel: 'Petrol',
        price: 600000, mileage: 12, engineCc: 1200, rating: 4.5),
    Car(id: '2', name: 'Maruti Suzuki Swift', brand: 'Maruti', model: 'Swift',
        bodyType: 'Sedan', variant: 'Manual', fuel: 'Diesel',
        price: 750000, mileage: 30, engineCc: 1200, rating: 4.2),
    Car(id: '3', name: 'Maruti Suzuki Baleno', brand: 'Maruti', model: 'Baleno',
        bodyType: 'Sedan', variant: 'Automatic', fuel: 'Petrol',
        price: 900000, mileage: 45, engineCc: 1197, rating: 3.8),
    Car(id: '4', name: 'Audi A6', brand: 'Audi', model: 'Audi A6',
        bodyType: 'Sedan', variant: 'Automatic', fuel: 'Petrol',
        price: 6500000, mileage: 20, engineCc: 1984, rating: 4.7),
    Car(id: '5', name: 'Audi Q3', brand: 'Audi', model: 'Audi Q3',
        bodyType: 'SUV', variant: 'Automatic', fuel: 'Diesel',
        price: 4500000, mileage: 60, engineCc: 1968, rating: 4.1),
    Car(id: '6', name: 'BMW 3 Series', brand: 'BMW', model: 'BMW 3 Series',
        bodyType: 'Sedan', variant: 'Automatic', fuel: 'Diesel',
        price: 5800000, mileage: 15, engineCc: 1998, rating: 4.6),
    Car(id: '7', name: 'BMW X1', brand: 'BMW', model: 'BMW X1',
        bodyType: 'SUV', variant: 'Automatic', fuel: 'Petrol',
        price: 4900000, mileage: 80, engineCc: 1499, rating: 3.4),
    Car(id: '8', name: 'Datsun GO', brand: 'Datsun', model: 'GO',
        bodyType: 'MUV', variant: 'Manual', fuel: 'CNG',
        price: 500000, mileage: 90, engineCc: 1198, rating: 2.9),
  ];

  Future<List<Car>> search(String query, CarFilter f) async {
    await Future.delayed(const Duration(milliseconds: 500)); // fake network

    final q = query.trim().toLowerCase();

    return _all.where((c) {
      final matchesQuery = q.isEmpty || c.name.toLowerCase().contains(q);

      final matchesBrand = f.brands.isEmpty || f.brands.contains(c.model);
      final matchesBody = f.bodyTypes.isEmpty || f.bodyTypes.contains(c.bodyType);
      final matchesVariant = f.variants.isEmpty || f.variants.contains(c.variant);
      final matchesFuel = f.fuels.isEmpty || f.fuels.contains(c.fuel);

      // 4 and 3 ticked -> a 4.5 rating counts as 4
      final matchesRating =
          f.ratings.isEmpty || f.ratings.contains(c.rating.floor());

      final matchesBudget = f.budget == null ||
          (c.price >= f.budget!.start && c.price <= f.budget!.end);
      final matchesMileage = f.mileage == null ||
          (c.mileage >= f.mileage!.start && c.mileage <= f.mileage!.end);
      final matchesCc = f.engineCc == null ||
          (c.engineCc >= f.engineCc!.start && c.engineCc <= f.engineCc!.end);

      return matchesQuery &&
          matchesBrand &&
          matchesBody &&
          matchesVariant &&
          matchesFuel &&
          matchesRating &&
          matchesBudget &&
          matchesMileage &&
          matchesCc;
    }).toList();
  }
}

final carRepositoryProvider = Provider<CarRepository>((ref) {
  return CarRepository();
});