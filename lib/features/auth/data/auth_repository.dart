import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learning/features/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers.dart' show sharedPrefsProvider;

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  String toString() {
    return message;
  }
}

class AuthRepository {

  final SharedPreferences prefs;

  AuthRepository(this.prefs);

  static const _fakeUsers  = {
    'arun@test.com': {'id': 'u1', 'name': 'Arun'},
    'priya@test.com': {'id': 'u2', 'name': 'Priya'},
  };


  Future<User> login(String email, String password ) async {
    await Future.delayed(const Duration(seconds: 1));
    final data = _fakeUsers[email];
    if(data == null) throw Exception('User illa. arun@test.com try pannunga');
    if (password != '123456') throw AuthException('Wrong password (123456)');

    final user = User(
        id: data['id']!,
        name: data['name']!,
        email: email,
        token: 'fake-jwt-${DateTime.now().millisecondsSinceEpoch}',
    );
    await prefs.setString('session', jsonEncode(user.toJson()));
    return user;

  }


  Future <void> logout() async{
    await prefs.remove('session');
  }

  Future <User?> getSavedUser() async{
   final raw =  prefs.getString('session');
   if (raw == null) return null;
   return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}

 final authRepositoryProvider = Provider<AuthRepository> ((ref) {
   return AuthRepository(ref.watch(sharedPrefsProvider ));
 });