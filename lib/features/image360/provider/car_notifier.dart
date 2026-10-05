import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/image360/data/image_repository.dart';
import 'package:riverpod_learning/features/image360/model/car_image.dart';

class CarNotifier extends AsyncNotifier<CarImage>{

  @override
  Future<CarImage> build() {
    return ref.watch(imageRepositoryProvider).getCar();
  }

  Future<void> refreshCar() async {
      state = const AsyncLoading();
      try {
        final car = await ref.read(imageRepositoryProvider).getCar();
        state = AsyncData(car);
      }catch(e,st){
        state = AsyncError(e, st);
      }
  }
}

final carImageNotifierProvider = AsyncNotifierProvider<CarNotifier,CarImage>(CarNotifier.new);