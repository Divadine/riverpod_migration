import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/car_filter_search/provider/car_search_notifier.dart';
import 'package:riverpod_learning/features/car_filter_search/provider/filter_notifier.dart';
import 'package:riverpod_learning/features/car_filter_search/provider/search_query_notifier.dart';
import 'package:riverpod_learning/features/car_filter_search/widget/filter_sheet.dart';


class CarSearchScreen extends ConsumerWidget {
  const CarSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carsState = ref.watch(carSearchProvider);
    final filterCount =ref.watch(appliedFilterProvider.select((f) => f.activeCount));


    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search cars',
                border: OutlineInputBorder(),
              ),
              onChanged: ref.read(searchQueryProvider.notifier).onChanged,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ActionChip(
                label: Text('Filter by${filterCount > 0 ? ' ($filterCount)' : ''}'),
                avatar: const Icon(Icons.tune, size: 18),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const FilterSheet(),
                ),
              ),
            ),
          ),
          Expanded(
            child: carsState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
              data: (cars) {
                if (cars.isEmpty) {
                  return const Center(child: Text('No cars found'));
                }
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(cars[i].name),
                    subtitle: Text('${cars[i].fuel} • ₹${cars[i].price}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}