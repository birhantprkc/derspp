class SourceItem {
  final String id;
  final String name;
  final String parentId;
  final bool isParent;
  final String? buyUrl;

  SourceItem({
    required this.id,
    required this.name,
    required this.parentId,
    required this.isParent,
    this.buyUrl,
  });

  factory SourceItem.fromJson(Map<String, dynamic> json) {
    final parentVal = json['parent'];
    bool isParent = false;
    if (parentVal is bool) {
      isParent = parentVal;
    } else if (parentVal is String) {
      isParent = parentVal.toLowerCase() == 'true' || parentVal == '1';
    } else if (parentVal is int) {
      isParent = parentVal == 1;
    }

    return SourceItem(
      id: json['id'].toString(),
      name: json['nm'] ?? '',
      parentId: json['pid']?.toString() ?? '',
      isParent: isParent,
      buyUrl: json['buy_url'],
    );
  }
}
