import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/cars/model/car_model.dart';

const popularModels = [
  CarModel(
    id: '1',
    brand: 'Maruthi Suzuki',
    name: 'WagonR',
    image: 'assets/images/wagonr.png',
    price: '12.09 - 13.05 lk',
    cc: '1200cc',
    gear: 'Manual',
  ),

  CarModel(
    id: '2',
    brand: 'Maruthi Suzuki',
    name: 'Swift',
    image: 'assets/images/swift.png',
    price: '10.09 - 12.05 lk',
    cc: '1200cc',
    gear: 'Manual',
  ),
];
final popularModelsProvider =Provider<List<CarModel>>((ref) {
  return popularModels;
});

const upcomingCarsModels = [
  CarModel(
    id: '3',
    brand: 'Maruthi suzki',
    name: 'Wagonar',
    image: 'assets/images/wagonr.png',
    launchDate: 'Apr-02-2026',
  ),
  CarModel(
    id: '4',
    brand: 'Maruthi suzki',
    name: 'Wagonar',
    image: 'assets/images/wagonr.png',
    launchDate: 'Apr-02-2026',
  ),

];
final upcomingCarsProvider =Provider<List<CarModel>>((ref) {
  return upcomingCarsModels;
});


// ---------- Search (See all page) ----------
class PopularSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;
}

final popularSearchProvider =
NotifierProvider<PopularSearchNotifier, String>(PopularSearchNotifier.new);

final filteredPopularModelsProvider = Provider<List<CarModel>>((ref) {
  final query = ref.watch(popularSearchProvider).trim().toLowerCase();
  final cars = ref.watch(popularModelsProvider);

  if (query.isEmpty) return cars;

  return cars
      .where((c) =>
  c.brand.toLowerCase().contains(query) ||
      c.name.toLowerCase().contains(query))
      .toList();
});



// ---------- Bookmark ----------
class BookmarkNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {}; // bookmark pannina car id-gal inga irukkum

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id); // already irundha remove
    } else {
      state = {...state, id}; // illa-na add
    }
  }
}

final bookmarkProvider =NotifierProvider<BookmarkNotifier, Set<String>>(BookmarkNotifier.new);


// ---------- Upcoming search ----------
class UpcomingSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;
}

final upcomingSearchProvider =
NotifierProvider<UpcomingSearchNotifier, String>(UpcomingSearchNotifier.new);

final filteredUpcomingCarsProvider = Provider<List<CarModel>>((ref) {
  final query = ref.watch(upcomingSearchProvider).trim().toLowerCase();
  final cars = ref.watch(upcomingCarsProvider);

  if (query.isEmpty) return cars;

  return cars
      .where((c) =>
  c.brand.toLowerCase().contains(query) ||
      c.name.toLowerCase().contains(query))
      .toList();
});