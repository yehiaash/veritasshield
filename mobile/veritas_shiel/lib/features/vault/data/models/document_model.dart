class DocumentModel {
  final int id;
  final String title;
  final String? category;
  final String? filePath;
  final DateTime createdAt;

  DocumentModel({
    required this.id,
    required this.title,
    this.category,
    this.filePath,
    required this.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      filePath: json['file_path'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'file_path': filePath,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
