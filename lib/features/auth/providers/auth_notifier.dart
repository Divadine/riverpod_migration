import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/auth/data/auth_repository.dart';
import 'package:riverpod_learning/features/auth/models/user.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() {
    return ref.read(authRepositoryProvider).getSavedUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading<User?>();
    try{
      final user = await ref.read(authRepositoryProvider).login(email, password);
      state = AsyncData(user);
    }catch(e){
      state = AsyncError(e, StackTrace.current);
    }

  }

  Future<void> logout() async {

    await ref.read(authRepositoryProvider).logout();

    state = const AsyncData(null);
  }
}

final authProvider= AsyncNotifierProvider<AuthNotifier,User?>(AuthNotifier.new);