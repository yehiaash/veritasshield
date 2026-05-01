import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';

class ContractPreview extends StatelessWidget {
  final String text;
  final List<String> highlightedPhrases;

  const ContractPreview({
    super.key,
    required this.text,
    required this.highlightedPhrases,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Document Preview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              children: _buildTextSpans(),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans() {
    List<TextSpan> spans = [];
    String remainingText = text;

    // Very basic highlighting logic for demonstration
    // In a real app, this would use a more robust regex or offset-based approach
    for (String phrase in highlightedPhrases) {
      int index = remainingText.indexOf(phrase);
      if (index != -1) {
        // Text before phrase
        spans.add(TextSpan(text: remainingText.substring(0, index)));
        // Highlighted phrase
        spans.add(TextSpan(
          text: phrase,
          style: TextStyle(
            backgroundColor: Colors.red.withOpacity(0.2),
            color: Colors.red.shade900,
            fontWeight: FontWeight.bold,
          ),
        ));
        remainingText = remainingText.substring(index + phrase.length);
      }
    }
    spans.add(TextSpan(text: remainingText));
    return spans;
  }
}
