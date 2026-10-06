enum AuthMode { login, signup }

extension AuthModeX on AuthMode {
  String get title => this == AuthMode.login ? 'Login' : 'Sign up';

  String get subtitle => this == AuthMode.login
      ? 'Enter your registered phone number to login.'
      : 'Create your account with your phone number.';

  String get buttonText => title;
}

class AuthTexts {
  static const String verificationTitle = 'Verification';
  static const String verificationSubtitle =
      'Enter the code sent to your mobile number.';
}