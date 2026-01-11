import 'dart:ui';
import 'package:http/http.dart' as http;
import '../models/book_content.dart';
import '../models/question.dart';
import '../models/source_item.dart';
import 'source_service.dart';

class F2SourceService implements SourceService {
  final http.Client _client = http.Client();
  String? _lastCacheKey;
  String? _cachedHtml;
  String _normalizeBaseUrl(String url) {
    String normalized = url.endsWith('/')
        ? url.substring(0, url.length - 1)
        : url;

    if (normalized.toLowerCase().endsWith('/solutions')) {
      normalized = normalized.substring(0, normalized.length - 10);
    } else if (normalized.toLowerCase().endsWith('/solution')) {
      normalized = normalized.substring(0, normalized.length - 9);
    }
    return normalized;
  }

  Future<String> _getSolutionHtml(String? baseUrl, String questionId) async {
    if (baseUrl == null) throw Exception('Base URL is null');

    final cacheKey = '$baseUrl|$questionId';
    if (_lastCacheKey == cacheKey && _cachedHtml != null) {
      return _cachedHtml!;
    }

    final normalizedBaseUrl = _normalizeBaseUrl(baseUrl);

    final solutionUrl =
        '$normalizedBaseUrl/ShowSolution?testQuestionId=$questionId';
    final response = await _client.get(Uri.parse(solutionUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load solution: ${response.statusCode}');
    }
    _lastCacheKey = cacheKey;
    _cachedHtml = response.body;
    return _cachedHtml!;
  }

  @override
  Future<List<SourceItem>> fetchSourceList(String id, String baseUrl) async {
    final normalizedBaseUrl = _normalizeBaseUrl(baseUrl);

    String url;
    if (id == 'root' || id == '-1') {
      url = '$normalizedBaseUrl/ClassList';
    } else if (id.startsWith('class_')) {
      final classId = id.replaceFirst('class_', '');
      url = '$normalizedBaseUrl/LessonList?classId=$classId';
    } else if (id.startsWith('lesson_')) {
      final parts = id.replaceFirst('lesson_', '').split('_');
      final lessonId = parts[0];
      final classId = parts[1];
      url = '$normalizedBaseUrl/BookList?classId=$classId&lessonId=$lessonId';
    } else if (id.startsWith('book_')) {
      final bookId = id.replaceFirst('book_', '');
      url = '$normalizedBaseUrl/BookList?bookId=$bookId';
      url = '$normalizedBaseUrl/ContentList?bookId=$bookId';
    } else if (id.startsWith('content_')) {
      final parts = id.replaceFirst('content_', '').split('_');
      final contentId = parts[0];
      final bookId = parts[1];
      url = '$normalizedBaseUrl/ContentList?bookId=$bookId&parentId=$contentId';
    } else if (id.startsWith('test_')) {
      final testId = id.replaceFirst('test_', '').split('_')[0];
      url = '$normalizedBaseUrl/QuestionList?testId=$testId&bookLetType=0';
    } else {
      url = '$normalizedBaseUrl/ClassList';
    }

    final response = await _client.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load: ${response.statusCode}');
    }

    final html = response.body;
    final List<SourceItem> items = [];

    final decoResult = _decodeHtml(html);

    if (id == 'root' || id == '-1' || !id.contains('_')) {
      final regExp = RegExp(
        r"classClick\(\{\s*classId:\s*(\d+),\s*title:\s*'([^']+)'\}\)",
      );
      for (final match in regExp.allMatches(decoResult)) {
        items.add(
          SourceItem(
            id: 'class_${match.group(1)}',
            name: match.group(2)!,
            isParent: true,
            parentId: id,
          ),
        );
      }
    } else if (id.startsWith('class_')) {
      final regExp = RegExp(
        r"lessonClick\(\{\s*lessonId:\s*(\d+),classId:\s*(\d+),\s*title:\s*'([^']+)'\}\)",
      );
      for (final match in regExp.allMatches(decoResult)) {
        items.add(
          SourceItem(
            id: 'lesson_${match.group(1)}_${match.group(2)}',
            name: match.group(3)!,
            isParent: true,
            parentId: id,
          ),
        );
      }
    } else if (id.startsWith('lesson_')) {
      final regExp = RegExp(
        r"bookClick\(\{bookId:(\d+),classId:(\d+),lessonId:(\d+),isGroup:\s*(true|false),title:'([^']+)'\}\)",
      );
      for (final match in regExp.allMatches(decoResult)) {
        items.add(
          SourceItem(
            id: 'book_${match.group(1)}',
            name: match.group(5)!,
            isParent: true,
            parentId: id,
          ),
        );
      }
    } else if (id.startsWith('book_') || id.startsWith('content_')) {
      final regExp = RegExp(
        r"contentClick\(\{\s*contentId:\s*(\d+),\s*bookId:\s*(\d+),\s*isTest:\s*(true|false),\s*title:\s*'([^']+)'\}\)",
      );
      for (final match in regExp.allMatches(decoResult)) {
        final isTest = match.group(3) == 'true';
        final bid = match.group(2);
        items.add(
          SourceItem(
            id: '${isTest ? 'test_' : 'content_'}${match.group(1)!}_$bid',
            name: match.group(4)!,
            isParent: !isTest,
            parentId: id,
          ),
        );
      }
    } else if (id.startsWith('test_')) {
      final regExp = RegExp(r"showSolution\('([^']+)',(\d+)\)");
      for (final match in regExp.allMatches(decoResult)) {
        items.add(
          SourceItem(
            id: 'question_${match.group(2)}',
            name: match.group(1)!,
            isParent: false,
            parentId: id,
          ),
        );
      }
    }

    return items;
  }

  @override
  Future<BookContent> fetchBookContent(String id, String baseUrl) async {
    final items = await fetchSourceList(id, baseUrl);
    final questions = items.map((item) {
      final qId = item.id.replaceFirst('question_', '');
      return Question(
        id: qId,
        name: item.name,
        order: item.name.split('.')[0].trim(),
        solvedId: qId,
        solvedType: 'f2',
        swfUrl: '',
        videoUrl: qId,
      );
    }).toList();

    return BookContent(
      questions: questions,
      status: '1',
      name: '',
      parentId: id,
    );
  }

  @override
  Future<Map<String, String?>> discoverPublisherInfo(String url) async {
    final normalizedUrl = _normalizeBaseUrl(url);
    return {'id': 'root', 'apiUrl': normalizedUrl};
  }

  @override
  Future<String> fetchXmlContent(String? baseUrl, String videoUrl) async {
    final html = await _getSolutionHtml(baseUrl, videoUrl);

    final match = RegExp(r'data-xaml="([^"]+)"').firstMatch(html);
    if (match != null) {
      final xamlUrl = match.group(1)!;
      final xamlResponse = await _client.get(Uri.parse(xamlUrl));
      if (xamlResponse.statusCode == 200) return xamlResponse.body;
    }

    throw Exception('XAML content not found');
  }

  @override
  Future<Size?> fetchSwfSize(String? baseUrl, String swfUrl) async {
    final html = await _getSolutionHtml(baseUrl, swfUrl);
    final wMatch = RegExp(r'data-w="(\d+)"').firstMatch(html);
    final hMatch = RegExp(r'data-h="(\d+)"').firstMatch(html);
    if (wMatch != null && hMatch != null) {
      return Size(
        double.parse(wMatch.group(1)!),
        double.parse(hMatch.group(1)!),
      );
    }
    return null;
  }

  @override
  Future<String?> fetchJpgUrl(
    String? baseUrl,
    String pdfUrl,
    double x,
    double y,
  ) async {
    final html = await _getSolutionHtml(baseUrl, pdfUrl);
    final match = RegExp(r'data-png="([^"]+)"').firstMatch(html);
    if (match != null) return match.group(1);
    return null;
  }

  @override
  Future<String?> fetchAudioUrl(String? baseUrl, String questionId) async {
    final html = await _getSolutionHtml(baseUrl, questionId);
    final match = RegExp(r'data-sound="([^"]+)"').firstMatch(html);
    if (match != null) return match.group(1);
    return null;
  }

  Future<String?> fetchMp4Url(String? baseUrl, String questionId) async {
    final html = await _getSolutionHtml(baseUrl, questionId);

    final sourceMatch = RegExp(
      r'<source[^>]+src="([^"]+\.mp4)"[^>]*type="video/mp4"',
    ).firstMatch(html);
    if (sourceMatch != null) return sourceMatch.group(1);

    final videoMatch = RegExp(
      r'<video[^>]+src="([^"]+\.mp4)"',
    ).firstMatch(html);
    if (videoMatch != null) return videoMatch.group(1);

    final anyMp4Match = RegExp(r'"(https?://[^"]+\.mp4)"').firstMatch(html);
    if (anyMp4Match != null) return anyMp4Match.group(1);

    return null;
  }

  Future<Map<String, String?>> detectContentType(
    String? baseUrl,
    String questionId,
  ) async {
    final html = await _getSolutionHtml(baseUrl, questionId);

    final mp4Match = RegExp(r'"(https?://[^"]+\.mp4)"').firstMatch(html);
    if (mp4Match != null) {
      return {'type': 'mp4', 'url': mp4Match.group(1)};
    }

    final xamlMatch = RegExp(r'data-xaml="([^"]+)"').firstMatch(html);
    if (xamlMatch != null) {
      return {'type': 'xaml', 'url': xamlMatch.group(1)};
    }

    return {'type': 'unknown', 'url': null};
  }

  String _decodeHtml(String input) {
    return input
        .replaceAll(r'\u0131', 'ı')
        .replaceAll(r'\u0130', 'İ')
        .replaceAll(r'\u00FC', 'ü')
        .replaceAll(r'\u00DC', 'Ü')
        .replaceAll(r'\u00F6', 'ö')
        .replaceAll(r'\u00D6', 'Ö')
        .replaceAll(r'\u00E7', 'ç')
        .replaceAll(r'\u00C7', 'Ç')
        .replaceAll(r'\u015F', 'ş')
        .replaceAll(r'\u015E', 'Ş')
        .replaceAll(r'\u011F', 'ğ')
        .replaceAll(r'\u011E', 'Ğ')
        .replaceAll('&#252;', 'ü')
        .replaceAll('&uml;', 'ü')
        .replaceAll('\t', ' ');
  }
}
