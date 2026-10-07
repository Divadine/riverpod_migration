import 'package:flutter/material.dart';
import 'package:riverpod_learning/shared_widgets/app_icon_widget.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';
import 'package:riverpod_learning/shared_widgets/asset_images.dart';
import '../model/car_model_item.dart';

class CarModelCards extends StatelessWidget {
  final CarModelItem model;
  final bool isSelected;
  final VoidCallback onTap;

  const CarModelCards({
    super.key,
    required this.model,
    required this.onTap,
    this.isSelected = false,
  });

  Widget _image(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const AppIconWidget(
          assetPath: AssetImages.loginImage,
          fit: BoxFit.contain,
        ),
      );
    }
    return AppIconWidget(assetPath: path, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFEAEAEA),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(child: Center(child: _image(model.image))),
            const SizedBox(height: 10),
            AppText(
              text: model.name,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              textAlign: TextAlign.center,
              maxLine: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}