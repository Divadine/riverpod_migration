import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';
import '../provider/car_provider.dart';
import '../widget/car_type_card.dart';
import 'car_models_screen.dart';

class TypesOfCarScreen extends ConsumerWidget {
  const TypesOfCarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final types = ref.watch(carTypesProvider);
    final selected = ref.watch(selectedTypeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: 'Types',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: types.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, i) {
                  final item = types[i];
                  return CarTypeCards(
                    item: item,
                    isSelected: selected?.id == item.id,
                    onTap: () {
                      // 1. store the selected type in the provider
                      ref.read(selectedTypeProvider.notifier).select(item);
                      // 2. open the models screen (it reads the provider)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CarModelScreen(),
                        ),
                      );
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