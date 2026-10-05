import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/car_filter_search/data/car_repository.dart';
import 'package:riverpod_learning/features/car_filter_search/model/car.dart';
import 'package:riverpod_learning/features/car_filter_search/provider/search_query_notifier.dart';
import 'filter_notifier.dart';

class CarSearchNotifier extends AsyncNotifier<List<Car>> {
  @override
  Future<List<Car>> build() {
    final query = ref.watch(searchQueryProvider);
    final filter = ref.watch(appliedFilterProvider);
    return ref.watch(carRepositoryProvider).search(query, filter);
  }
}

final carSearchProvider =
AsyncNotifierProvider<CarSearchNotifier, List<Car>>(
    CarSearchNotifier.new);