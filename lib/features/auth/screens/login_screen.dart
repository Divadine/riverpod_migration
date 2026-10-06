import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_notifier.dart';

class LoginScreens extends ConsumerStatefulWidget {
  const LoginScreens({super.key});
  @override
  ConsumerState<LoginScreens> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreens> {

  final _email = TextEditingController(text: 'arun@test.com');
  final _password = TextEditingController(text: '123456');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(authProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    final loading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [

            const SizedBox(height: 32),
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading
                  ? null
                  : () => ref
                .read(authProvider.notifier)
                .login(_email.text.trim(), _password.text),
                  child: loading
                      ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Login'),
              ),
            ),



          ]),
        ),
      ),
    );
  }
}