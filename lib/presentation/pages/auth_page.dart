import 'package:flutter/material.dart';
import 'package:habithubtest/presentation/pages/sign_in.dart';
import 'package:habithubtest/presentation/pages/sign_up.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;
  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInPage(showRegisterPage: toggleScreen);
    } else {
      return SignUpPage(showLoginPage: toggleScreen);
    }
  }
}
