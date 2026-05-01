import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/analysis/data/models/analysis_model.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/vault/presentation/pages/vault_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/analysis/presentation/pages/analysis_screen.dart';
import '../../features/analysis/presentation/pages/contract_analysis_screen.dart';

class Routes {
  static const String splash = '/splash';
  static const String onboarding = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String vault = '/vault';
  static const String profile = '/profile';
  static const String analysis = '/analysis';
  static const String contractAnalysis = '/contract-analysis';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case Routes.vault:
        return MaterialPageRoute(builder: (_) => const VaultScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.analysis:
        return MaterialPageRoute(builder: (_) => const AnalysisScreen());
      case Routes.contractAnalysis:
        final analysis = settings.arguments as AnalysisModel;
        return MaterialPageRoute(
          builder: (_) => ContractAnalysisScreen(analysis: analysis),
        );
      default:
        return null;
    }
  }
}
