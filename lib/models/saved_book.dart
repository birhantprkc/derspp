class SavedBook {
  final String id;
  String name;
  final String sourceId;
  final String baseUrl;
  final DateTime addedDate;
  String? coverImage;
  String? originalCoverImage;
  final String sourceType;

  SavedBook({
    required this.id,
    required this.name,
    required this.sourceId,
    required this.baseUrl,
    required this.addedDate,
    this.coverImage,
    this.originalCoverImage,
    this.sourceType = 'fsource',
  });
}
