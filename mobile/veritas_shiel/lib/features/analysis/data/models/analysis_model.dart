class AnalysisModel {
  final int id;
  final int documentId;
  final int riskPercentage;
  final String summary;
  final List<AnalysisFlag> flags;
  final String contractText;

  AnalysisModel({
    required this.id,
    required this.documentId,
    required this.riskPercentage,
    required this.summary,
    required this.flags,
    required this.contractText,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      id: json['id'],
      documentId: json['document_id'],
      riskPercentage: json['risk_percentage'],
      summary: json['summary'],
      flags: (json['flags'] as List)
          .map((flag) => AnalysisFlag.fromJson(flag))
          .toList(),
      contractText: json['contract_text'],
    );
  }
}

class AnalysisFlag {
  final String title;
  final String description;
  final String severity; // e.g., 'high', 'medium', 'low'

  AnalysisFlag({
    required this.title,
    required this.description,
    required this.severity,
  });

  factory AnalysisFlag.fromJson(Map<String, dynamic> json) {
    return AnalysisFlag(
      title: json['title'],
      description: json['description'],
      severity: json['severity'],
    );
  }
}
