import 'package:riverpod_learning/shared_widgets/asset_images.dart';

class CarModelItem {
  final String id;
  final String typeId; // links the model to its CarTypeItem.id
  final String name;
  final String image;

  const CarModelItem({
    required this.id,
    required this.typeId,
    required this.name,
    this.image = AssetImages.loginImage,
  });
}