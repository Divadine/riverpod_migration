import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_notifier.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key});
  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {

  final _title = TextEditingController();
  Priority _priority = Priority.medium;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _submit() {
    if (_title.text.trim().isEmpty) return;
    ref.read(taskProvider.notifier).add(_title.text, _priority);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _title,
          autofocus: true,
          decoration: const InputDecoration(
              labelText: 'Task title',
              border: OutlineInputBorder()),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('High'),
              selected: _priority == Priority.high,
              onSelected: (selected) {
                setState(() {
                  _priority = Priority.high;
                });
              },
            ),

            const SizedBox(width: 8),

            ChoiceChip(
              label: const Text('Medium'),
              selected: _priority == Priority.medium,
              onSelected: (selected) {
                setState(() {
                  _priority = Priority.medium;
                });
              },
            ),

            const SizedBox(width: 8),

            ChoiceChip(
              label: const Text('Low'),
              selected: _priority == Priority.low,
              onSelected: (selected) {
                setState(() {
                  _priority = Priority.low;
                });
              },
            ),
          ],
        ),
        // SegmentedButton<Priority>(
        //   segments: [
        //     for (final p in Priority.values)
        //       ButtonSegment(value: p, label: Text(p.name)),
        //   ],
        //   selected: {_priority},
        //   onSelectionChanged: (s) => setState(() => _priority = s.first),
        // ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: _submit, child: const Text('Add')),
        ),
      ]),
    );
  }
}