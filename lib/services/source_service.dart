import 'dart:ui';
import '../models/book_content.dart';
import '../models/source_item.dart';

abstract class SourceService {
  Future<List<SourceItem>> fetchSourceList(String id, String baseUrl);
  Future<BookContent> fetchBookContent(String id, String baseUrl);
  Future<Map<String, String?>> discoverPublisherInfo(String url);

  Future<String> fetchXmlContent(String? baseUrl, String videoUrl);
  Future<Size?> fetchSwfSize(String? baseUrl, String swfUrl);
  Future<String?> fetchJpgUrl(
    String? baseUrl,
    String pdfUrl,
    double x,
    double y,
  );
  Future<String?> fetchAudioUrl(String? baseUrl, String questionId);
  Future<String?> resolveVideoUrl(String? baseUrl, String videoUrl);
}
