import 'package:flutter/material.dart';
import 'package:riverpod_learning/shared_widgets/app_icon_widget.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';
import 'package:riverpod_learning/shared_widgets/asset_images.dart';

class CarModelItem {
  final String id;
  final String name;
  final String image;
  final String typeName;

  const CarModelItem({
    required this.id,
    required this.name,
    required this.image,
    this.typeName = '',
  });
}

class TypesOfCarModels extends StatefulWidget {
  final String typeName;
  final List<CarModelItem>? items;
  final String? selectedModelId;
  final ValueChanged<CarModelItem>? onSelect;

  const TypesOfCarModels({
    super.key,
    this.typeName = 'Hatchbacks',
    this.items,
    this.selectedModelId,
    this.onSelect,
  });

  static Map<String, List<CarModelItem>> get defaultModelsByType => {
        'Hatchbacks': const [
          CarModelItem(id: '1', name: 'Alto K10', image: AssetImages.loginImage, typeName: 'Hatchbacks'),
          CarModelItem(id: '2', name: 'S-Presso', image: AssetImages.loginImage, typeName: 'Hatchbacks'),
          CarModelItem(id: '3', name: 'Celerio', image: AssetImages.loginImage, typeName: 'Hatchbacks'),
          CarModelItem(id: '4', name: 'WagonR', image: AssetImages.loginImage, typeName: 'Hatchbacks'),
          CarModelItem(id: '5', name: 'Swift', image: AssetImages.loginImage, typeName: 'Hatchbacks'),
        ],
        'Sedan': const [
          CarModelItem(id: '6', name: 'Dzire', image: AssetImages.loginImage, typeName: 'Sedan'),
          CarModelItem(id: '7', name: 'Honda City', image: AssetImages.loginImage, typeName: 'Sedan'),
          CarModelItem(id: '8', name: 'Verna', image: AssetImages.loginImage, typeName: 'Sedan'),
          CarModelItem(id: '9', name: 'Ciaz', image: AssetImages.loginImage, typeName: 'Sedan'),
          CarModelItem(id: '10', name: 'Virtus', image: AssetImages.loginImage, typeName: 'Sedan'),
          CarModelItem(id: '11', name: 'Slavia', image: AssetImages.loginImage, typeName: 'Sedan'),
        ],
        'SUV': const [
          CarModelItem(id: '12', name: 'Brezza', image: AssetImages.loginImage, typeName: 'SUV'),
          CarModelItem(id: '13', name: 'Creta', image: AssetImages.loginImage, typeName: 'SUV'),
          CarModelItem(id: '14', name: 'Nexon', image: AssetImages.loginImage, typeName: 'SUV'),
          CarModelItem(id: '15', name: 'Thar', image: AssetImages.loginImage, typeName: 'SUV'),
          CarModelItem(id: '16', name: 'Fortuner', image: AssetImages.loginImage, typeName: 'SUV'),
          CarModelItem(id: '17', name: 'Harrier', image: AssetImages.loginImage, typeName: 'SUV'),
        ],
        'MUV': const [
          CarModelItem(id: '18', name: 'Ertiga', image: AssetImages.loginImage, typeName: 'MUV'),
          CarModelItem(id: '19', name: 'XL6', image: AssetImages.loginImage, typeName: 'MUV'),
          CarModelItem(id: '20', name: 'Innova Crysta', image: AssetImages.loginImage, typeName: 'MUV'),
          CarModelItem(id: '21', name: 'Carens', image: AssetImages.loginImage, typeName: 'MUV'),
          CarModelItem(id: '22', name: 'Triber', image: AssetImages.loginImage, typeName: 'MUV'),
        ],
        'Super Luxury': const [
          CarModelItem(id: '23', name: 'Mercedes Maybach', image: AssetImages.loginImage, typeName: 'Super Luxury'),
          CarModelItem(id: '24', name: 'BMW 7 Series', image: AssetImages.loginImage, typeName: 'Super Luxury'),
          CarModelItem(id: '25', name: 'Audi A8', image: AssetImages.loginImage, typeName: 'Super Luxury'),
          CarModelItem(id: '26', name: 'Porsche Panamera', image: AssetImages.loginImage, typeName: 'Super Luxury'),
        ],
        'Convertible': const [
          CarModelItem(id: '27', name: 'BMW Z4', image: AssetImages.loginImage, typeName: 'Convertible'),
          CarModelItem(id: '28', name: 'Mini Cooper', image: AssetImages.loginImage, typeName: 'Convertible'),
          CarModelItem(id: '29', name: 'Mustang Convertible', image: AssetImages.loginImage, typeName: 'Convertible'),
        ],
      };

  @override
  State<TypesOfCarModels> createState() => _TypesOfCarModelsState();
}

class _TypesOfCarModelsState extends State<TypesOfCarModels> {
  String? selectedModelId;

  @override
  void initState() {
    super.initState();
    selectedModelId = widget.selectedModelId;
  }

  List<CarModelItem> get _modelsList {
    if (widget.items != null && widget.items!.isNotEmpty) {
      return widget.items!;
    }
    return TypesOfCarModels.defaultModelsByType[widget.typeName] ??
        [
          CarModelItem(
            id: 'default1',
            name: '${widget.typeName} Model 1',
            image: AssetImages.loginImage,
            typeName: widget.typeName,
          ),
          CarModelItem(
            id: 'default2',
            name: '${widget.typeName} Model 2',
            image: AssetImages.loginImage,
            typeName: widget.typeName,
          ),
        ];
  }

  @override
  Widget build(BuildContext context) {
    final models = _modelsList;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: AppText(
          text: widget.typeName,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFEEEEEE),
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: 'Models',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: models.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final model = models[index];
                  final isSelected = selectedModelId == model.id;
                  return _CarModelCard(
                    model: model,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedModelId = model.id;
                      });
                      widget.onSelect?.call(model);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarModelCard extends StatelessWidget {
  final CarModelItem model;
  final bool isSelected;
  final VoidCallback onTap;

  const _CarModelCard({
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  Widget _buildModelImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const AppIconWidget(
          assetPath: AssetImages.loginImage,
          fit: BoxFit.contain,
        ),
      );
    }
    return AppIconWidget(
      assetPath: imagePath,
      fit: BoxFit.contain,
    );
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
            color: isSelected ? Colors.red : const Color(0xFFEAEAEA),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: _buildModelImage(model.image),
              ),
            ),
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
