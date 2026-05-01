import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import 'package:veritas_shiel/features/analysis/presentation/widgets/contract_preview.dart';
import 'package:veritas_shiel/features/analysis/presentation/widgets/flag_item.dart';
import 'package:veritas_shiel/features/analysis/presentation/widgets/summary_risk_card.dart';
import 'package:veritas_shiel/features/onboarding/presentation/widgets/custom_button.dart';
import 'package:veritas_shiel/features/analysis/data/models/analysis_model.dart';

class ContractAnalysisScreen extends StatelessWidget {
  final AnalysisModel analysis;

  const ContractAnalysisScreen({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.darkBrown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contract Analysis',
          style: TextStyle(color: AppColors.darkBrown, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SummaryRiskCard(
                riskPercentage: analysis.riskPercentage,
                riskColor: analysis.riskPercentage > 60 ? Colors.red : Colors.orange,
                summary: analysis.summary,
              ),
              ContractPreview(
                text: analysis.contractText,
                highlightedPhrases: analysis.flags.map((f) => f.title).toList(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  'Detected Issues',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
              ...analysis.flags.map((flag) => FlagItem(
                title: flag.title,
                description: flag.description,
                icon: flag.severity == 'high' ? Icons.warning_amber_rounded : Icons.info_outline,
                color: flag.severity == 'high' ? Colors.red : Colors.orange,
              )),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'View Full Contract',
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.darkBrown),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Download Report',
                          style: TextStyle(color: AppColors.darkBrown, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
