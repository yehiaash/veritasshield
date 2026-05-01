import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';

class SummaryRiskCard extends StatelessWidget {
  final int riskPercentage;
  final String summary;
  final Color riskColor;

  const SummaryRiskCard({
    super.key,
    required this.riskPercentage,
    required this.summary,
    required this.riskColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: riskPercentage / 100,
                  backgroundColor: Colors.black12,
                  valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                  strokeWidth: 12,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$riskPercentage%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                  const Text(
                    'Risk Level',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            summary,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkBrown,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
