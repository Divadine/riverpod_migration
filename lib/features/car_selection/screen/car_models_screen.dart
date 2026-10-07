import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/shared_widgets/app_text.dart';
import '../provider/car_provider.dart';
import '../widget/car_model_card.dart';

class CarModelScreen extends ConsumerWidget {
  const CarModelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(selectedTypeProvider); // title comes from here
    final models = ref.watch(carModelsProvider); // models of that type(selected)
    final selectedModel = ref.watch(selectedModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: AppText(
          text: type?.name ?? 'Models',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFEEEEEE), height: 2 ),
        ),
      ),
      body: SafeArea(
        child: models.isEmpty
            ? const Center(child: AppText(text: 'No models found'))
            : SingleChildScrollView(
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
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final model = models[index];
                  return CarModelCards(
                    model: model,
                    isSelected: selectedModel?.id == model.id,
                    onTap: () => ref.read(selectedModelProvider.notifier).select(model),

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