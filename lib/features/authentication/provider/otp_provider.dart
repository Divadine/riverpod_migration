import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_mode.dart';
import '../models/otp_state.dart';

const int kOtpLength = 4;
const int kOtpSeconds = 120;

class OtpArgs {
  final String phone;
  final AuthMode mode;

  const OtpArgs({required this.phone, required this.mode});

  @override
  bool operator ==(Object other) =>
      other is OtpArgs && other.phone == phone && other.mode == mode;

  @override
  int get hashCode => Object.hash(phone, mode);
}

class OtpNotifier extends Notifier<OtpState> {
  OtpNotifier(this.args);
  final OtpArgs args;

  Timer? _timer;

  @override
  OtpState build() {
    ref.onDispose(() => _timer?.cancel());
    _startTimer();
    return const OtpState(secondsLeft: kOtpSeconds);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state.secondsLeft <= 1) {
        t.cancel();
        state = state.copyWith(secondsLeft: 0);
      } else {
        state = state.copyWith(secondsLeft: state.secondsLeft - 1);
      }
    });
  }

  void onOtpChanged(String value) {
    state = state.copyWith(otp: value, clearError: true);
  }

  Future<void> resend() async {
    if (!state.canResend) return;
    state = state.copyWith(secondsLeft: kOtpSeconds, otp: '', clearError: true);
    _startTimer();
    // TODO: call resend OTP API with args.phone
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> verify() async {
    if (state.otp.length < kOtpLength) {
      state = state.copyWith(error: 'Please enter OTP');
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // TODO: call verify API with args.phone, state.otp
      //  args.mode == AuthMode.login  -> login verify
      //  args.mode == AuthMode.signup -> register verify
      await Future.delayed(const Duration(seconds: 1));

      // demo: treat 0000 as wrong OTP, remove when using real API
      if (state.otp == '0000') throw Exception('Invalid OTP');

      state = state.copyWith(isLoading: false, isVerified: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Invalid OTP');
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final otpProvider = NotifierProvider.autoDispose
    .family<OtpNotifier, OtpState, OtpArgs>(OtpNotifier.new);