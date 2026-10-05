import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/auth/providers/auth_notifier.dart';
import 'package:riverpod_learning/features/tasks/models/task.dart';
import 'package:riverpod_learning/features/tasks/task_data/task_repository.dart';

class TaskNotifier  extends AsyncNotifier<List<Task>>{

  @override
  Future<List<Task>> build()async{
    //1 user =>
    final user = ref.watch(authProvider).value;

    if(user == null) return [];
    //2 task =>
   return ref.watch(taskRepositoryProvider).fetchTask(user.id);
  }


  //
  // Future<void> update(List<Task> Function(List<Task>)  chnage) async {
  //
  // }

  Future<void> add(String title, Priority priority) async  {
    final user = ref.read(authProvider).value;
    if(user == null) return;

    final previous = state.value ?? [];

    final newTask = [
    Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        priority: priority,
        createdAt: DateTime.now()
    ),
      ...previous,
    ];

    state = AsyncData(newTask);

    try{
      await ref.read(taskRepositoryProvider).saveTask(user.id, newTask);
    }catch(e){

      state = AsyncData(previous);
      rethrow;
    }

  }
  Future<void> delete(String id) async {
    final user = ref.read(authProvider).value;
    if(user == null) return ;

    final previous = state.value ?? [];
    final updated = previous.where((t) => t.id != id).toList();
    state = AsyncData(updated);
    try{
      await ref.read(taskRepositoryProvider).saveTask(user.id, updated);
    }catch(e,st){
      state = AsyncError(e, st);
    }
  }


  Future<void> toggle(String id) async {
    final user = ref.read(authProvider).value;
    if (user == null) return;

    final previous = state.value ?? [];

    final updated = previous.map((t) {
      if(t.id == id){
        return t.copyWith(isDone: !t.isDone);
      }
      return t;
    }).toList();

    state = AsyncData(updated);

    try{
      await ref.read(taskRepositoryProvider).saveTask(user.id, updated);
    }catch(e,st){
      state = AsyncError(e, st);
    }
  }


}

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(TaskNotifier.new);