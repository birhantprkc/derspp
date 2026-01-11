import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../models/animation_model.dart';
import '../services/xml_parser_service.dart';
import '../services/source_service.dart';
import 'dart:ui';

class DownloadService {
  static Future<AnimationModel> prepareQuestionData(
    Question question,
    SourceService sourceService, [
    String? baseUrl,
    bool preferPdf = false,
  ]) async {
    final startTime = DateTime.now();
    debugPrint(
      'Hazırlama başladı (${preferPdf ? 'PDF' : 'JPG'}): ${question.name}',
    );

    if (question.videoUrl == null) {
      throw Exception('Video (XML) URL\'si bulunamadı');
    }

    final xmlTarget = question.videoUrl!;
    final swfTarget = (question.swfUrl != null && question.swfUrl!.isNotEmpty)
        ? question.swfUrl!
        : xmlTarget;
    final pdfTarget = (question.pdfUrl != null && question.pdfUrl!.isNotEmpty)
        ? question.pdfUrl!
        : xmlTarget;

    final futures = await Future.wait([
      sourceService.fetchXmlContent(baseUrl, xmlTarget),
      sourceService.fetchSwfSize(baseUrl, swfTarget),
      (!preferPdf)
          ? sourceService.fetchJpgUrl(baseUrl, pdfTarget, 0, 0)
          : Future.value(null),
      (question.audioUrl == null || question.audioUrl!.isEmpty)
          ? sourceService.fetchAudioUrl(baseUrl, xmlTarget)
          : Future.value(null),
    ]);

    final xmlContent = futures[0] as String;
    final swfSize = futures[1] as Size?;
    final initialJpgUrl = futures[2] as String?;
    final fetchedAudioUrl = futures[3] as String?;

    final fetchDuration = DateTime.now().difference(startTime);
    debugPrint('Paralel fetch: ${fetchDuration.inMilliseconds}ms');

    final audioPath =
        (question.audioUrl != null && question.audioUrl!.isNotEmpty)
        ? question.audioUrl
        : fetchedAudioUrl;

    final parseStart = DateTime.now();
    final xmlData = await XmlParserService.decodeAndParseXmlIsolate(xmlContent);
    final parseDuration = DateTime.now().difference(parseStart);
    debugPrint('XML parsing: ${parseDuration.inMilliseconds}ms');

    if (!preferPdf) {
      final pdfOffset = xmlData.pdfOffset;
      if (pdfOffset.dx != 0 || pdfOffset.dy != 0) {
        final jpgUrl = await sourceService.fetchJpgUrl(
          baseUrl,
          pdfTarget,
          pdfOffset.dx,
          pdfOffset.dy,
        );
        if (jpgUrl != null) {
          xmlData.backgroundJpgUrl = jpgUrl;
        }
      } else if (initialJpgUrl != null) {
        xmlData.backgroundJpgUrl = initialJpgUrl;
      }
    }

    if (preferPdf) {
      if (!question.hasPdf && xmlData.backgroundJpgUrl == null) {
        final jpgUrl = await sourceService.fetchJpgUrl(
          baseUrl,
          pdfTarget,
          0,
          0,
        );
        if (jpgUrl != null) {
          xmlData.backgroundJpgUrl = jpgUrl;
          xmlData.preferPdf = false;
        } else {
          xmlData.preferPdf = true;
        }
      } else {
        xmlData.preferPdf = true;
      }
    } else {
      xmlData.preferPdf = false;
    }

    if (swfSize != null) {
      xmlData.swfWidth = swfSize.width;
      xmlData.swfHeight = swfSize.height;
    }

    if (audioPath != null) {
      xmlData.audioPath = audioPath;
    }

    if (question.pdfUrl != null && question.pdfUrl!.isNotEmpty) {
      xmlData.pdfUrl = question.pdfUrl;
    }

    final totalDuration = DateTime.now().difference(startTime);
    debugPrint('Toplam süre: ${totalDuration.inMilliseconds}ms');

    return xmlData;
  }
}
