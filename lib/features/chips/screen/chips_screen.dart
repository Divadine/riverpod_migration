// ---------------------------------------------------------------------------
// UI
// ---------------------------------------------------------------------------

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/chips/provider/chips_provider.dart';
import 'package:riverpod_learning/features/chips/widgets/bottombar_widget.dart';
import 'package:riverpod_learning/features/chips/widgets/chips_widgets.dart';

class BrandPickerScreen extends ConsumerWidget {
  const BrandPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What brand do you like?',
                      style: TextStyle(
                        color: kAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select any 5 brands you like.',
                      style: TextStyle(color: kMuted, fontSize: 14, height: 1.4),
                    ),
                    for (final entry in kBrandGroups.entries) ...[
                      const SizedBox(height: 20),
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final brand in entry.value) BrandChip(brand: brand),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const BottomBar(),
          ],
        ),
      ),
    );
  }
}