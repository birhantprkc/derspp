class Question {
  final String id;
  final String name;
  final String solvedId;
  final String solvedType;
  final String? swfUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String? mp4Url;
  final String order;

  String? get pdfUrl => swfUrl?.replaceAll('.swf', '.pdf');

  Question({
    required this.id,
    required this.name,
    required this.solvedId,
    required this.solvedType,
    this.swfUrl,
    this.videoUrl,
    this.audioUrl,
    this.mp4Url,
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
      solvedId: json['solved_id'].toString(),
      solvedType: json['solved_type'] ?? '',
      swfUrl: json['swf'],
      videoUrl: video,
      audioUrl: json['audio'],
      mp4Url: json['mp4'],
      order: json['order'].toString(),
    );
  }

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  bool get hasPdf => swfUrl != null && swfUrl!.isNotEmpty;
  bool get hasMp4 => mp4Url != null && mp4Url!.isNotEmpty;
}
