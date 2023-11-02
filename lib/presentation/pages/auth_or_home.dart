import 'package:flutter/material.dart';
import 'package:habithubtest/presentation/pages/after_auth_page.dart';
import 'package:habithubtest/presentation/pages/auth_page.dart';
import 'package:habithubtest/presentation/pages/loading.dart';
import 'package:habithubtest/services/auth.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else if (snapshot.hasData) {
          return const AfterAuthPage();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
