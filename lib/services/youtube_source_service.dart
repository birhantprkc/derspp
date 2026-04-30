import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/book_content.dart';
import '../models/source_item.dart';
import '../models/question.dart';
import 'source_service.dart';
import 'cors_proxy_service.dart';

class YoutubeSourceService implements SourceService {
  final YoutubeExplode _yt = YoutubeExplode();

  void _syncProxy() {
    if (kIsWeb) {
      YoutubeHttpClient.corsProxyUrl = CorsProxyService.instance.proxyUrl ?? '';
    }
  }

  Future<String?> resolveStreamUrl(String videoUrl) async {
    _syncProxy();
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoUrl);
      final streamInfo = manifest.muxed.withHighestBitrate();
      return streamInfo.url.toString();
    } catch (e) {
      return videoUrl;
    }
  }

  @override
  Future<List<SourceItem>> fetchSourceList(String id, String baseUrl) async {
    _syncProxy();
    try {
      final playlist = await _yt.playlists.get(baseUrl);
      final List<SourceItem> items = [];
      final videos = await _yt.playlists.getVideos(playlist.id).toList();

      for (var video in videos) {
        items.add(
          SourceItem(
            id: video.id.value,
            name: video.title,
            parentId: id,
            isParent: true,
          ),
        );
      }
      return items;
    } catch (e) {
      throw Exception('YouTube video listesi yüklenemedi: $e');
    }
  }

  @override
  Future<BookContent> fetchBookContent(String id, String baseUrl) async {
    _syncProxy();
    try {
      final video = await _yt.videos.get(id);
      final description = video.description;
      final List<Question> chapters = [];

      final regExp = RegExp(r'((?:\d{1,2}:)?\d{1,2}:\d{2})[\s-]*([^\n]+)');
      final matches = regExp.allMatches(description).toList();

      if (matches.isEmpty) {
        chapters.add(
          Question(
            id: video.id.value,
            name: video.title,
            videoUrl: video.url,
            order: '1',
          ),
        );
      } else {
        for (int i = 0; i < matches.length; i++) {
          final startStr = matches[i].group(1)!;
          final title = matches[i].group(2)!.trim();
          final startTime = _parseDuration(startStr);

          double? endTime;
          if (i < matches.length - 1) {
            endTime = _parseDuration(matches[i + 1].group(1)!);
          } else {
            endTime = video.duration?.inSeconds.toDouble();
          }

          chapters.add(
            Question(
              id: '${video.id.value}_$i',
              name: title,
              videoUrl: video.url,
              order: (i + 1).toString(),
              startTime: startTime,
              endTime: endTime,
            ),
          );
        }
      }

      return BookContent(
        status: '1',
        name: video.title,
        questions: chapters,
        parentId: id,
      );
    } catch (e) {
      throw Exception('Video bölümleri yüklenemedi: $e');
    }
  }

  double _parseDuration(String timeStr) {
    final parts = timeStr.split(':').map(int.parse).toList();
    if (parts.length == 3) {
      return (parts[0] * 3600 + parts[1] * 60 + parts[2]).toDouble();
    } else {
      return (parts[0] * 60 + parts[1]).toDouble();
    }
  }

  @override
  Future<Map<String, String?>> discoverPublisherInfo(String url) async {
    _syncProxy();
    try {
      String? extractedPlaylistId;
      try {
        final uri = Uri.parse(url);
        extractedPlaylistId = uri.queryParameters['list'];
      } catch (_) {}

      if (extractedPlaylistId == null || extractedPlaylistId.isEmpty) {
        extractedPlaylistId = PlaylistId.parsePlaylistId(url);
      }

      if (extractedPlaylistId != null && extractedPlaylistId.isNotEmpty) {
        return {'id': extractedPlaylistId, 'apiUrl': url, 'type': 'youtube'};
      }
    } catch (_) {}
    return {'id': null, 'apiUrl': null};
  }

  @override
  Future<String> fetchXmlContent(String? b, String v) async => '';
  @override
  Future<Size?> fetchSwfSize(String? b, String s) async => null;
  @override
  Future<String?> fetchJpgUrl(String? b, String p, double x, double y) async =>
      null;
  @override
  Future<String?> fetchAudioUrl(String? b, String q) async => null;

  @override
  Future<String?> resolveVideoUrl(String? baseUrl, String videoUrl) async {
    return resolveStreamUrl(videoUrl);
  }

  void dispose() => _yt.close();
}
