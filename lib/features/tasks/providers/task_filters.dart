import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/tasks/models/task.dart';
import 'package:riverpod_learning/features/tasks/providers/task_notifier.dart';


enum TaskFilters {
  all,pending,done
}

class TaskFilterNotifier extends Notifier<TaskFilters> {

  @override
  TaskFilters build() {
    return TaskFilters.all;
  }


  void setFilter(TaskFilters filter) {
    state = filter;
  }

}

final taskFilterProvider = NotifierProvider<TaskFilterNotifier,TaskFilters>(TaskFilterNotifier.new);

final visibleTaskProvider = Provider<List<Task>>((ref) {
  final filter = ref.watch(taskFilterProvider);
  final tasks = ref.watch(taskProvider).value ??[];

  if(filter == TaskFilters.all){
    return tasks;
  }

  if(filter == TaskFilters.pending){
    return tasks.where((p) => p.isDone == false).toList();
  }

  if(filter == TaskFilters.done){
    return tasks.where((p) => p.isDone == true).toList();
  }

  return tasks;
});


class TaskStats {
  final int total;
  final int done;

  TaskStats( this.total,  this.done);

  int get pending {
    return total - done;
  }


}

final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasks = ref.watch(taskProvider).value ?? [];
  int total = tasks.length;
  
  int done = tasks.where((t) => t.isDone == true).length;
  return TaskStats(total, done);
});