import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/routes/app_router.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  void _onSkip() {
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // Page 1
          OnboardingPage(
            index: 0,
            illustration: Image.asset(
              'assets/images/landing1.png',
              fit: BoxFit.contain,
            ),
            title: 'Your Legal Life, Connected',
            description:
                'Instead of looking at documents alone, we build a persistent memory of your legal history.\nSee how all your contracts connect in one unified system.',
            buttonText: 'Next',
            onNext: _onNext,
            onSkip: _onSkip,
          ),
          // Page 2
          OnboardingPage(
            index: 1,
            illustration: Image.asset(
              'assets/images/image2.png',
              fit: BoxFit.contain,
            ),
            title: 'Conflict Detection',
            description:
                'Our Clash Engine automatically scans new contracts against your old ones. We catch conflicting obligations and legal contradictions before you sign.',
            buttonText: 'Next',
            onNext: _onNext,
            onSkip: _onSkip,
          ),
          // Page 3
          OnboardingPage(
            index: 2,
            illustration: Image.asset(
              'assets/images/image3.png',
              fit: BoxFit.contain,
            ),
            title: 'Transparency at a Glance',
            description:
                "Spot \"sneaky\" clauses instantly with our visual Risk Heatmap.\nWe assign a Predatory Score to every term so you can make informed decisions.",
            buttonText: 'Start',
            onNext: _onNext,
            onSkip: _onSkip,
            isLastPage: true,
          ),
        ],
      ),
    );
  }
}
