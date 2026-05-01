import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';

class WarningCard extends StatelessWidget {
  final String title;
  final String expiryText;

  const WarningCard({
    super.key,
    required this.title,
    required this.expiryText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE6C99C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.darkBrown.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 50,
              color: AppColors.darkBrown,
            ),
            const SizedBox(height: 12),
            Text(
              '$title:\n$expiryText',
              style: const TextStyle(
                color: AppColors.darkBrown,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
