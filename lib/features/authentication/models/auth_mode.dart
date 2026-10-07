enum AuthMode {
  login,
  signup;

  String title() {
    if (this == AuthMode.login) {
      return 'Login';
    } else {
      return 'Sign up';
    }
  }

  String subtitle() {
    if (this == AuthMode.login) {
      return 'Enter your registered phone number to login.';
    } else {
      return 'Create your account with your phone number.';
    }
  }

  String buttonText() {
    return title();
  }
}

class AuthTexts {
  static const String verificationTitle = 'Verification';
  static const String verificationSubtitle =
      'Enter the code sent to your mobile number.';
}