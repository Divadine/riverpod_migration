import 'package:flutter/material.dart';
import 'package:riverpod_learning/core/theme/color.dart';
import 'package:riverpod_learning/shared_widgets/app_icon_widget.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';
import 'package:riverpod_learning/shared_widgets/asset_images.dart';
import 'package:riverpod_learning/shared_widgets/types_of_car_models.dart';

class CarTypeItem {
  final String id;
  final String name;
  final String image;

  const CarTypeItem({
    required this.id,
    required this.name,
    required this.image,
  });
}

class TypesOfCars extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isSelected;

  const TypesOfCars({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    this.onTap,
    this.width,
    this.height,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.red : const Color(0xFFEAEAEA),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow:  [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top light grey rounded image box
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:AppColors.cardCar,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: AppIconWidget(
                    assetPath: image,
                    size: 48,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Bottom car title name
            AppText(
              text: name,
              fontSize: 14,
              fontWeight: FontWeight.w500,
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

class TypesOfCarsGrid extends StatefulWidget {
  final String title;
  final List<CarTypeItem>? items;
  final String? selectedId;
  final ValueChanged<CarTypeItem>? onSelect;

  const TypesOfCarsGrid({
    super.key,
    this.title = 'Types',
    this.items,
    this.selectedId,
    this.onSelect,
  });

  @override
  State<TypesOfCarsGrid> createState() => _TypesOfCarsGridState();
}

class _TypesOfCarsGridState extends State<TypesOfCarsGrid> {
  String? selectedId;

  static const List<CarTypeItem> defaultItems = [
    CarTypeItem(id: '1', name: 'Hatchbacks', image: AssetImages.loginImage),
    CarTypeItem(id: '2', name: 'Sedan', image: AssetImages.loginImage),
    CarTypeItem(id: '3', name: 'SUV', image: AssetImages.loginImage),
    CarTypeItem(id: '4', name: 'MUV', image: AssetImages.loginImage),
    CarTypeItem(id: '5', name: 'Super Luxury', image: AssetImages.loginImage),
    CarTypeItem(id: '6', name: 'Convertible', image: AssetImages.loginImage),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   selectedId = widget.selectedId;
  // }

  @override
  Widget build(BuildContext context) {
    final list = widget.items ?? defaultItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title.isNotEmpty) ...[
          AppText(
            text: widget.title,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          const SizedBox(height: 14),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final item = list[index];
            final isSelected = selectedId == item.id;
            return TypesOfCars(
              id: item.id,
              name: item.name,
              image: item.image,
              isSelected: isSelected,
              onTap: () {
                setState(() => selectedId = item.id);
                widget.onSelect?.call(item);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TypesOfCarModels(
                      typeName: item.name,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class TypesOfCarsScreen extends StatelessWidget {
  const TypesOfCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: TypesOfCarsGrid(),
        ),
      ),
    );
  }
}
