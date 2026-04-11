class Question {
  final String id;
  final String name;
  final String? swfUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String order;
  final double? startTime;
  final double? endTime;

  String? get pdfUrl => swfUrl?.replaceAll('.swf', '.pdf');

  Question({
    required this.id,
    required this.name,
    this.swfUrl,
    this.videoUrl,
    this.audioUrl,
    required this.order,
    this.startTime,
    this.endTime,
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
      startTime: (json['start_time'] as num?)?.toDouble(),
      endTime: (json['end_time'] as num?)?.toDouble(),
    );
  }

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  bool get hasPdf => swfUrl != null && swfUrl!.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'id': id,
    'swf': swfUrl,
    'video': videoUrl,
    'audio': audioUrl,
    'start_time': startTime,
    'end_time': endTime,
  };
}
