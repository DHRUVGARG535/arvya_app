class JournalModel {
  final String id;
  final String ambienceTitle;
  final String mood;
  final String text;
  final DateTime createdAt;

  JournalModel({
    required this.id,
    required this.ambienceTitle,
    required this.mood,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'ambienceTitle': ambienceTitle,
        'mood': mood,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'],
      ambienceTitle: json['ambienceTitle'],
      mood: json['mood'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}