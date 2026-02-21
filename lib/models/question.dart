class Question {
  final String id;
  final String name;
  final String? swfUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String order;

  String? get pdfUrl => swfUrl?.replaceAll('.swf', '.pdf');

  Question({
    required this.id,
    required this.name,
    this.swfUrl,
    this.videoUrl,
    this.audioUrl,
    required this.order,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    String? video = json['video'];
    if (json['solved_type'] == 'youtube' && json['url'] != null) {
      video = json['url'];
    }

    return Question(
      id: json['id'].toString(),
      name: json['nm'] ?? '',
      swfUrl: json['swf'],
      videoUrl: video,
      audioUrl: json['audio'],
      order: json['order'].toString(),
    );
  }

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  bool get hasPdf => swfUrl != null && swfUrl!.isNotEmpty;
}
