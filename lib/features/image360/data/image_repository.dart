import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/image360/model/car_image.dart';

class ImageRepository {

  Future<CarImage> getCar() async {
    await Future.delayed(const Duration(seconds: 1));
    return CarImage(
        id: '1',
        name:  'BMW 3 Series',
        panoramaImage:
'https://stimg.cardekho.com/images/carexteriorimages/630x420/BMW/3-Series/10574/1761732994122/front-left-side-47.jpg',    );

  }
}

final imageRepositoryProvider = Provider<ImageRepository>(
    (ref) {
      return ImageRepository();
    }
);