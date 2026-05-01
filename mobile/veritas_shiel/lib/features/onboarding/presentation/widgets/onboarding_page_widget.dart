import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import 'custom_button.dart';

class OnboardingPage extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isLastPage;
  final int index;

  const OnboardingPage({
    super.key,
    required this.illustration,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onNext,
    required this.onSkip,
    required this.index,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 3),
          // Illustration Container
          SizedBox(
            height: size.height * 0.3,
            width: double.infinity,
            child: illustration,
          ),
          const SizedBox(height: 24),
          // Page Indicator (Moved here)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == index ? AppColors.primary : Colors.transparent,
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
          // Content
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const Spacer(flex: 3),
          // Bottom Navigation
          isLastPage
              ? SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: buttonText,
                    onPressed: onNext,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: onSkip,
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    CustomButton(
                      text: buttonText,
                      onPressed: onNext,
                    ),
                  ],
                ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
