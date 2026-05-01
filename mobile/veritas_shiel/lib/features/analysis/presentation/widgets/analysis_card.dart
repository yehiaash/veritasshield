import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import 'package:veritas_shiel/core/routes/app_router.dart';
import '../../data/models/analysis_model.dart';

class AnalysisCard extends StatelessWidget {
  final AnalysisModel analysis;
  final String title;
  final String category;
  final String amount;
  final String startDate;
  final String duration;
  final IconData categoryIcon;
  final Color riskColor;

  const AnalysisCard({
    super.key,
    required this.analysis,
    required this.title,
    required this.category,
    required this.amount,
    required this.startDate,
    required this.duration,
    required this.categoryIcon,
    required this.riskColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            Routes.contractAnalysis,
            arguments: analysis,
          ),
          borderRadius: BorderRadius.circular(40),
          child: Ink(
            padding: const EdgeInsets.all(20.0),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contract: $title',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          Text(
                            'Category: $category',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          Text(
                            'Amount: $amount',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          Text(
                            'Start Date: $startDate',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          Text(
                            'Duration: $duration',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Icon(categoryIcon, size: 60, color: AppColors.darkBrown),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: analysis.riskPercentage / 100,
                            backgroundColor: Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                            strokeWidth: 8,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Risks',
                              style: TextStyle(fontSize: 10, color: Colors.black54),
                            ),
                            Text(
                              '${analysis.riskPercentage}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: riskColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Text(
                      '${analysis.flags.length} Conflicts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: analysis.flags.isEmpty ? Colors.lightGreen : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
