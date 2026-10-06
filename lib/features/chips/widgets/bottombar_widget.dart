import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/chips/provider/chips_provider.dart';

class BottomBar extends ConsumerWidget {
  const BottomBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canContinue = ref.watch(canContinueProvider);

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {

            },
            child: const Text('Skip', style: TextStyle(color: kAccent)),
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: canContinue
                  ? () {
                final brands = ref.read(brandSelectionProvider);

                print('Selected: $brands');
              }
                  : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: kAccent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE3E3E3),
                disabledForegroundColor: const Color(0xFF8A8A8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}