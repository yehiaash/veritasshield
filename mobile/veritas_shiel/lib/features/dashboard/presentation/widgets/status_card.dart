import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';

class StatusCard extends StatelessWidget {
  final int protectedDocs;
  final int conflicts;
  final double conflictPercentage;

  const StatusCard({
    super.key,
    required this.protectedDocs,
    required this.conflicts,
    required this.conflictPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/logo2.png',
              height: 100, // Adjusted for card size
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Legal Shield is Active',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$protectedDocs Documents Protected | $conflicts Critical Conflicts Found',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: conflictPercentage / 100,
                  backgroundColor: Colors.black12,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkBrown),
                  strokeWidth: 8,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'conflicts',
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  Text(
                    '${conflictPercentage.toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
