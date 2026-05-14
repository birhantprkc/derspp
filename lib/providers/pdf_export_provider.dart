import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import '../database/database.dart';
import '../services/pdf_export_service.dart';
import '../services/source_factory.dart';
import '../services/f2_source_service.dart';

class PdfExportProvider extends ChangeNotifier {
  final AppDatabase _db;
  List<GeneratedPdf> _generatedPdfs = [];
  bool _isExporting = false;
  String _exportStatus = '';
  double _exportProgress = 0;

  PdfExportProvider(this._db) {
    loadGeneratedPdfs();
  }

  List<GeneratedPdf> get generatedPdfs => _generatedPdfs;
  bool get isExporting => _isExporting;
  String get exportStatus => _exportStatus;
  double get exportProgress => _exportProgress;

  Future<void> loadGeneratedPdfs() async {
    _generatedPdfs =
        await (_db.select(_db.generatedPdfs)..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
            .get();
    notifyListeners();
  }

  Future<void> exportQuestions({
    required List<SavedQuestion> questions,
    required String name,
    required List<int> folderIds,
    int columns = 2,
    Future<Uint8List?> Function(SavedQuestion)? onCaptureRequired,
  }) async {
    if (questions.isEmpty) return;

    _isExporting = true;
    _exportStatus = 'PDF oluşturuluyor...';
    _exportProgress = 0;
    notifyListeners();

    try {
      final manualCaptures = <int, Uint8List>{};
      if (onCaptureRequired != null) {
        for (int i = 0; i < questions.length; i++) {
          final q = questions[i];
          if (await _isQuestionVideo(q)) {
            _exportStatus = '${i + 1}. soru (Video) için kare yakalanıyor...';
            notifyListeners();
            final capture = await onCaptureRequired(q);
            if (capture != null) {
              manualCaptures[q.id] = capture;
            }
          }
        }
      }

      final filePath = await PdfExportService.exportQuestions(
        questions: questions,
        name: name,
        columns: columns,
        manualCaptures: manualCaptures,
        progressCallback: (current, total) {
          _exportProgress = current / total;
          _exportStatus = '$current / $total soru hazırlanıyor...';
          notifyListeners();
        },
      );

      final questionDbIds = questions.map((q) => q.id).toList();
      final questionCount = questions.length;

      await _db
          .into(_db.generatedPdfs)
          .insert(
            GeneratedPdfsCompanion.insert(
              name: name,
              filePath: filePath,
              folderIds: jsonEncode(folderIds),
              questionDbIds: jsonEncode(questionDbIds),
              questionCount: questionCount,
              columns: Value(columns),
            ),
          );

      _exportStatus = 'PDF oluşturuldu!';
      await loadGeneratedPdfs();
    } catch (e) {
      _exportStatus = 'Hata: $e';
      debugPrint('PDF export hatası: $e');
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  Future<void> markAsCompleted(int pdfId) async {
    final pdf = await (_db.select(
      _db.generatedPdfs,
    )..where((t) => t.id.equals(pdfId))).getSingleOrNull();
    if (pdf == null) return;

    final List<dynamic> questionIds = jsonDecode(pdf.questionDbIds);
    final now = DateTime.now();

    int getIntervalForStep(int step) {
      switch (step) {
        case 0:
          return 1;
        case 1:
          return 3;
        case 2:
          return 7;
        case 3:
          return 14;
        default:
          return 30;
      }
    }

    for (final qId in questionIds) {
      final sq = await (_db.select(
        _db.savedQuestions,
      )..where((t) => t.id.equals(qId as int))).getSingleOrNull();
      if (sq == null) continue;

      final newStep = sq.reviewStep + 1;
      final interval = getIntervalForStep(sq.reviewStep);
      final nextReview = now.add(Duration(days: interval));

      await (_db.update(
        _db.savedQuestions,
      )..where((t) => t.id.equals(qId))).write(
        SavedQuestionsCompanion(
          nextReviewDate: Value(nextReview),
          reviewStep: Value(newStep),
          lastReviewInterval: Value(interval),
        ),
      );

      await _db
          .into(_db.reviewLogs)
          .insert(ReviewLogsCompanion.insert(date: Value(now), type: Value(1)));
    }

    await deletePdf(pdfId);
  }

  Future<void> deletePdf(int id) async {
    final pdf = await (_db.select(
      _db.generatedPdfs,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (pdf != null) {
      try {
        final file = File(pdf.filePath);
        if (await file.exists()) await file.delete();
      } catch (_) {}
      await (_db.delete(_db.generatedPdfs)..where((t) => t.id.equals(id))).go();
      await loadGeneratedPdfs();
    }
  }

  Future<List<SavedQuestion>> getQuestionsForPdf(int pdfId) async {
    final pdf = await (_db.select(
      _db.generatedPdfs,
    )..where((t) => t.id.equals(pdfId))).getSingleOrNull();
    if (pdf == null) return [];

    final List<dynamic> questionIds = jsonDecode(pdf.questionDbIds);
    final questions = await (_db.select(
      _db.savedQuestions,
    )..where((t) => t.id.isIn(questionIds.cast<int>()))).get();

    final questionMap = {for (final q in questions) q.id: q};
    return questionIds
        .map((id) => questionMap[id as int])
        .whereType<SavedQuestion>()
        .toList();
  }

  Future<bool> _isQuestionVideo(SavedQuestion sq) async {
    try {
      if (sq.scraperType == 'youtube') return true;

      final data = jsonDecode(sq.rawJson);
      final videoUrl = data['videoUrl'] as String?;

      if (sq.scraperType == 'f2source') {
        final service = SourceFactory.getSourceService('f2source');
        if (service is F2SourceService) {
          final ct = await service.detectContentType(
            sq.baseUrl,
            videoUrl ?? sq.id.toString(),
          );
          return ct['type'] == 'mp4';
        }
      }

      if (videoUrl == null || videoUrl.isEmpty) return false;

      final url = videoUrl.toLowerCase();
      return url.endsWith('.mp4') || url.contains('.mp4?');
    } catch (_) {
      return false;
    }
  }
}
