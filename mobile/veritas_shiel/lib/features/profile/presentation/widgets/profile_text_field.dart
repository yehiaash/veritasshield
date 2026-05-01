import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String value;
  final bool isPassword;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.value,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkBrown,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.darkBrown, width: 1.5),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
