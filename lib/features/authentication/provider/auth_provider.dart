import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_mode.dart';
import '../models/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// returns true when OTP was sent successfully
  Future<bool> sendOtp({
    required AuthMode mode,
    required String phone,
    String name = '',
  }) async {
    if (mode == AuthMode.signup && name.trim().isEmpty) {
      state = state.copyWith(error: 'Please enter name');
      return false;
    }
    if (phone.trim().length != 10) {
      state = state.copyWith(error: 'Enter Valid Phone number');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // TODO: replace with your real API call
      //  login  -> if phone not registered: throw Exception('Phone number not exited');
      //  signup -> if already registered:   throw Exception('Phone number already exists');
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final authProvider =
NotifierProvider.autoDispose<AuthNotifier, AuthState>(AuthNotifier.new);