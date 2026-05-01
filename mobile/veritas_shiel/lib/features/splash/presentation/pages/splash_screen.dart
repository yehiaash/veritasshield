import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/token_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    // Check auth and first time status
    final bool isFirstTime = await TokenManager.isFirstTime();
    final bool shouldRemember = await TokenManager.shouldRemember();
    final String? token = await TokenManager.getAccessToken();

    // Small delay to show our custom splash logo if desired, or transition immediately
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Remove the native splash screen
    FlutterNativeSplash.remove();

    if (isFirstTime) {
      await TokenManager.setFirstTimeDone();
      Navigator.pushReplacementNamed(context, Routes.onboarding);
    } else if (shouldRemember && token != null) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image - Scaled based on screen width
            SvgPicture.asset(
              'assets/splash_logo.svg',
              width: size.width * 0.4, // 40% of screen width
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
