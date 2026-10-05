import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/core/providers.dart';
import 'package:riverpod_learning/features/tasks/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskRepository {
  final SharedPreferences prefs;

  TaskRepository(this.prefs);

  Future<List<Task>> fetchTask(String userId) async {
    await Future.delayed(const Duration(milliseconds: 700));
   final raw =  prefs.getString(userId);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveTask(String userId, List<Task> tasks) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final json = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(userId, json);
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepository(ref.watch(sharedPrefsProvider)));