import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_notifier.dart';
import '../models/task.dart';
import '../providers/task_filters.dart';
import '../providers/task_notifier.dart';
import 'add_task_sheet.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  Color _color(Priority p) {
    switch (p) {
      case Priority.high:
        return Colors.red;

      case Priority.medium:
        return Colors.orange;

      case Priority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final name = ref.watch(authProvider.select((a) => a.value?.name));
    //authProvider.select((a) => a.value?.name),



    final tasks = ref.watch(visibleTaskProvider);

    final stats = ref.watch(taskStatsProvider);

    final filter = ref.watch(taskFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, $name'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),

      floatingActionButton :FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddTaskSheet(),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //
      //   onPressed: () {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       builder: (_) => const AddTaskSheet(),
      //     );
      //   },
      // ),

      body: Column(
        children: [



          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    _stat('Total', stats.total),
                    _stat('Pending', stats.pending),
                    _stat('Done', stats.done),
                  ],
                ),
              ),
            ),
          ),


          Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: filter == TaskFilters.all,
                onSelected: (selected) {
                  ref
                      .read(taskFilterProvider.notifier)
                      .setFilter(TaskFilters.all);
                },
              ),

              ChoiceChip(
                label: const Text('Pending'),
                selected: filter == TaskFilters.pending,
                onSelected: (selected) {
                  ref
                      .read(taskFilterProvider.notifier)
                      .setFilter(TaskFilters.pending);
                },
              ),

              ChoiceChip(
                label: const Text('Done'),
                selected: filter == TaskFilters.done,
                onSelected: (selected) {
                  ref
                      .read(taskFilterProvider.notifier)
                      .setFilter(TaskFilters.done);
                },
              ),
            ],
          ),

          const SizedBox(height: 8),



          Expanded(
            child: tasks.isEmpty
                ? const Center(
              child: Text('Task ethuvum illa'),
            )
                : ListView.builder(
              itemCount: tasks.length,

              itemBuilder: (context, index) {
                final t = tasks[index];

                return Dismissible(
                  key: ValueKey(t.id),

                  background: Container(
                    color: Colors.blueGrey,
                  ),

                  onDismissed: (_) {
                    ref
                        .read(taskProvider.notifier)
                        .delete(t.id);
                  },

                  child: ListTile(
                    leading: Checkbox(
                      value: t.isDone,
                      onChanged: (_) {
                        ref
                            .read(taskProvider.notifier)
                            .toggle(t.id);
                      },
                    ),

                    title: Text(
                      t.title,
                      style: TextStyle(
                        decoration: t.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),

                    subtitle: Text(
                      t.priority.name.toUpperCase(),
                    ),

                    trailing: Icon(
                      Icons.flag,
                      color: _color(t.priority),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, int value) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
}