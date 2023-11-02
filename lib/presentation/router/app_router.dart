import 'package:flutter/material.dart';
import 'package:habithubtest/presentation/pages/after_auth_page.dart';
import 'package:habithubtest/presentation/pages/auth_or_home.dart';
import 'package:habithubtest/presentation/pages/auth_page.dart';
import 'package:habithubtest/presentation/pages/habit_page.dart';
import 'package:habithubtest/presentation/pages/home.dart';
import 'package:habithubtest/presentation/pages/journal_page.dart';
import 'package:habithubtest/presentation/pages/loading.dart';
import 'package:habithubtest/presentation/pages/pomotimer.dart';
import 'package:habithubtest/presentation/pages/pomotimer_settings.dart';
import 'package:habithubtest/presentation/pages/profile.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthOrHomePage());
      case '/afterauth':
        return MaterialPageRoute(builder: (_) => const AfterAuthPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/habit':
        return MaterialPageRoute(builder: (_) => const HabitPage());
      case '/journal':
        return MaterialPageRoute(builder: (_) => const JournalPage());
      case '/loading':
        return MaterialPageRoute(builder: (_) => const LoadingScreen());
      case '/pomodoro':
        return MaterialPageRoute(builder: (_) => const PomodoroPage());
      case '/pomodorosettings':
        return MaterialPageRoute(builder: (_) => const PomodoroSettings());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case '/authpage':
        return MaterialPageRoute(builder: (_) => const AuthPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
