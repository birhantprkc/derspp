import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/book_content.dart';
import '../models/source_item.dart';
import 'source_service.dart';
import 'cors_proxy_service.dart';

class FSourceService implements SourceService {
  final http.Client _client = http.Client();

  Uri _proxied(String url) =>
      Uri.parse(CorsProxyService.instance.wrapUrlString(url));

  @override
  Future<List<SourceItem>> fetchSourceList(String id, String baseUrl) async {
    final url = _proxied('$baseUrl?action=source_list&id=$id');

    try {
      final response = await _client.get(
        url,
        headers: {"Accept-Encoding": "gzip", "Connection": "keep-alive"},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      final sources = map['sources'] as List<dynamic>?;
      if (sources == null) return [];

      return List<SourceItem>.generate(
        sources.length,
        (i) => SourceItem.fromJson(sources[i] as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<BookContent> fetchBookContent(String id, String baseUrl) async {
    final url = _proxied('$baseUrl?action=content_list&id=$id');

    try {
      final response = await _client.get(
        url,
        headers: {"Accept-Encoding": "gzip", "Connection": "keep-alive"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BookContent.fromJson(data);
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('İçerik yüklenemedi: $e');
    }
  }

  @override
  Future<Map<String, String?>> discoverPublisherInfo(String url) async {
    String? discoveredId;
    String? discoveredApiUrl;

    try {
      final response = await _client.get(_proxied(url));
      if (response.statusCode == 200) {
        final body = response.body;

        final idRegExp = RegExp(r"get_sources\((\d+)\)");
        final idMatch = idRegExp.firstMatch(body);
        if (idMatch != null) {
          discoveredId = idMatch.group(1);
        }

        final apiRegExp = RegExp("var\\s+api_url\\s*=\\s*['\"]([^'\"]+)['\"]");
        final apiMatch = apiRegExp.firstMatch(body);
        if (apiMatch != null) {
          discoveredApiUrl = apiMatch.group(1);
        }
      }
    } catch (e) {
      debugPrint('Yayın bilgileri keşfedilemedi: $e');
    }

    if (discoveredId == null) {
      discoveredId = '1';
    }
    try {
      final uri = Uri.parse(url);
      final cleanedHost = uri.host.replaceAll('video', '');
      final cleanedPath = uri.path
          .replaceAll('video', '')
          .replaceAll('//', '/');

      discoveredApiUrl =
          '${uri.scheme}://$cleanedHost${cleanedPath.endsWith('/') ? cleanedPath : '$cleanedPath/'}mobile_solved/mobile_watch.php';
      debugPrint(discoveredApiUrl);
    } catch (e) {
      debugPrint('Default api url oluşturulamadı: $e');
    }
    if (discoveredApiUrl == null) {}

    return {'id': discoveredId, 'apiUrl': discoveredApiUrl};
  }

  String _extractDomain(String? url) {
    if (url == null) return '';
    final uri = Uri.parse(url);
    return "${uri.scheme}://${uri.host}";
  }

  @override
  Future<String> fetchXmlContent(String? baseUrl, String videoUrl) async {
    final domain = _extractDomain(baseUrl);
    try {
      if (domain.isNotEmpty) {
        final apiUrl =
            "$domain/soru_cozum/web_player/xaml2text.php?action=get-xml&url=$videoUrl";
        final response = await _client.get(_proxied(apiUrl));
        if (response.statusCode == 200 && response.body.isNotEmpty) {
          return response.body;
        }
      }
    } catch (e) {
      debugPrint('xaml2text.php hatası: $e');
    }

    final response = await _client.get(_proxied(videoUrl));
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('xml indirilemedi: HTTP ${response.statusCode}');
  }

  @override
  Future<Size?> fetchSwfSize(String? baseUrl, String swfUrl) async {
    final domain = _extractDomain(baseUrl);
    if (domain.isEmpty) return null;
    try {
      final sizeApiUrl =
          "$domain/soru_cozum/web_player/get-size.php?action=get-size&url=$swfUrl";

      final response = await _client.get(_proxied(sizeApiUrl));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final width = (json['0'] as num?)?.toDouble();
        final height = (json['1'] as num?)?.toDouble();
        if (width != null && height != null && width > 0 && height > 0) {
          return Size(width, height);
        }
      }
    } catch (e) {
      debugPrint('get-size boyut alınamadı: $e');
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
    final domain = _extractDomain(baseUrl);
    if (domain.isEmpty) return null;
    try {
      final phpUrl =
          "$domain/soru_cozum/web_player/pdf2jpg.php?action=pdf2jpg&url=$pdfUrl&x=$x&y=$y";

      final response = await _client.get(_proxied(phpUrl));
      if (response.statusCode == 200) {
        final body = response.body.trim();
        final urlMatch = RegExp(r'https?://[^\s<>"]+\.jpg').firstMatch(body);
        if (urlMatch != null) {
          return urlMatch.group(0);
        } else if (body.startsWith('http')) {
          return body;
        }
      }
    } catch (e) {
      debugPrint('jpg linki alınamadı: $e');
    }
    return null;
  }

  @override
  Future<String?> fetchAudioUrl(String? baseUrl, String questionId) async {
    return null;
  }
}
