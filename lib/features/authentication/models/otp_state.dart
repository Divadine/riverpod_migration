class OtpState {
  final String otp;
  final int secondsLeft;
  final bool isLoading;
  final bool isVerified;
  final String? error;

  const OtpState({
    this.otp = '',
    this.secondsLeft = 120,
    this.isLoading = false,
    this.isVerified = false,
    this.error,
  });

  bool get canResend => secondsLeft == 0;

  String get timerText {
    final m = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  OtpState copyWith({
    String? otp,
    int? secondsLeft,
    bool? isLoading,
    bool? isVerified,
    String? error,
    bool clearError = false,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      error: clearError ? null : (error ?? this.error),
    );
  }
}