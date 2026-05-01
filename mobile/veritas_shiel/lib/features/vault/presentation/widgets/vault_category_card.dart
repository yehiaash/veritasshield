import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';

class VaultCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const VaultCategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 140,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkBrown,
                  ),
                ),
                Icon(
                  icon,
                  size: 80,
                  color: AppColors.darkBrown,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
