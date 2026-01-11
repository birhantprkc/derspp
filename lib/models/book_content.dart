import 'question.dart';

class BookContent {
  final String status;
  final String name;
  final List<Question> questions;
  final String parentId;

  BookContent({
    required this.status,
    required this.name,
    required this.questions,
    required this.parentId,
  });

  factory BookContent.fromJson(Map<String, dynamic> json) {
    return BookContent(
      status: json['status'].toString(),
      name: json['nm'] ?? '',
      parentId: json['pid'] ?? '',
      questions:
          (json['contents'] as List?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }
}
