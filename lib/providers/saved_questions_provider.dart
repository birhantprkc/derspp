import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import '../database/database.dart';
import '../models/question.dart';

class SavedQuestionsProvider extends ChangeNotifier {
  final AppDatabase _db;
  List<QuestionFolder> _folders = [];
  List<SavedQuestion> _savedQuestions = [];
  List<ReviewLog> _activityLogs = [];

  SavedQuestionsProvider(this._db) {
    refreshFolders();
    _loadActivityLogs();
  }

  List<QuestionFolder> get folders => _folders;
  List<SavedQuestion> get savedQuestions => _savedQuestions;
  List<ReviewLog> get activityLogs => _activityLogs;

  Future<void> refreshFolders() async {
    _folders = await _db.select(_db.questionFolders).get();
    notifyListeners();
  }

  Future<void> _loadActivityLogs() async {
    _activityLogs = await _db.select(_db.reviewLogs).get();
    notifyListeners();
  }

  Map<DateTime, int> getHeatmapData() {
    final Map<DateTime, int> data = {};
    for (final log in _activityLogs) {
      final date = DateTime(log.date.year, log.date.month, log.date.day);
      data[date] = (data[date] ?? 0) + 1;
    }
    return data;
  }

  int getTotalSavedQuestions() {
    return _savedQuestions.length;
  }

  Future<Map<String, int>> getSummaryStats() async {
    final totalQuestions = await _db.select(_db.savedQuestions).get();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final dueQuestions = totalQuestions
        .where((q) => q.nextReviewDate.isBefore(today))
        .length;

    return {'total': totalQuestions.length, 'due': dueQuestions};
  }

  Future<Map<String, int>> getFolderStats(int folderId) async {
    final allIds = await _getAllFolderIdsRecursive(folderId);
    final allQuestions = await (_db.select(
      _db.savedQuestions,
    )..where((t) => t.folderId.isIn(allIds))).get();

    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    int toReview = 0;
    int newCount = 0;

    for (final q in allQuestions) {
      if (q.reviewStep == 0) {
        newCount++;
      } else if (q.nextReviewDate.isBefore(todayEnd) ||
          q.nextReviewDate.isAtSameMomentAs(todayEnd)) {
        toReview++;
      }
    }

    return {'toReview': toReview, 'new': newCount};
  }

  Future<Map<int, Map<String, int>>> getAllFolderStats() async {
    final allQuestions = await _db.select(_db.savedQuestions).get();
    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final Map<int, List<int>> folderIdCache = {};
    for (final folder in _folders) {
      folderIdCache[folder.id] = await _getAllFolderIdsRecursive(folder.id);
    }

    final Map<int, Map<String, int>> result = {};

    for (final folder in _folders) {
      final ids = folderIdCache[folder.id] ?? [folder.id];
      int toReview = 0;
      int total = 0;

      for (final q in allQuestions) {
        if (!ids.contains(q.folderId)) continue;
        total++;
        if (q.reviewStep > 0 && !q.nextReviewDate.isAfter(todayEnd)) {
          toReview++;
        }
      }

      result[folder.id] = {'toReview': toReview, 'total': total};
    }

    return result;
  }

  Map<DateTime, int> getHeatmapDataForWeeks(int weeks) {
    final Map<DateTime, int> data = {};
    final cutoff = DateTime.now().subtract(Duration(days: weeks * 7));

    for (final log in _activityLogs) {
      if (log.date.isBefore(cutoff)) continue;
      if (log.type != 1) continue;
      final day = DateTime(log.date.year, log.date.month, log.date.day);
      data[day] = (data[day] ?? 0) + 1;
    }
    return data;
  }

  int getCurrentStreak() {
    final reviewDays = <DateTime>{};
    for (final log in _activityLogs) {
      if (log.type != 1) continue;
      reviewDays.add(DateTime(log.date.year, log.date.month, log.date.day));
    }

    if (reviewDays.isEmpty) return 0;

    final today = DateTime.now();
    int streak = 0;
    DateTime cursor = DateTime(today.year, today.month, today.day);

    while (reviewDays.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Future<int> createFolder(String name, {int? parentId}) async {
    final id = await _db
        .into(_db.questionFolders)
        .insert(
          QuestionFoldersCompanion.insert(
            name: name,
            parentId: Value(parentId),
          ),
        );
    await refreshFolders();
    return id;
  }

  Future<void> deleteFolder(int id) async {
    final allIds = await _getAllFolderIdsRecursive(id);
    await (_db.delete(
      _db.savedQuestions,
    )..where((t) => t.folderId.isIn(allIds))).go();
    await (_db.delete(
      _db.questionFolders,
    )..where((t) => t.id.isIn(allIds))).go();
    await refreshFolders();
  }

  Future<List<int>> _getAllFolderIdsRecursive(int folderId) async {
    final ids = <int>[folderId];
    final subFolders = await (_db.select(
      _db.questionFolders,
    )..where((t) => t.parentId.equals(folderId))).get();

    for (final sub in subFolders) {
      ids.addAll(await _getAllFolderIdsRecursive(sub.id));
    }
    return ids;
  }

  Future<SavedQuestion?> getNextReviewQuestion(int folderId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final allFolderIds = await _getAllFolderIdsRecursive(folderId);

    final query = _db.select(_db.savedQuestions)
      ..where(
        (t) =>
            t.folderId.isIn(allFolderIds) &
            t.nextReviewDate.isSmallerOrEqualValue(today),
      )
      ..orderBy([
        (t) =>
            OrderingTerm(expression: t.nextReviewDate, mode: OrderingMode.asc),
      ])
      ..limit(1);

    return await query.getSingleOrNull();
  }

  Future<void> logActivity(int type) async {
    await _db
        .into(_db.reviewLogs)
        .insert(
          ReviewLogsCompanion.insert(
            date: Value(DateTime.now()),
            type: Value(type),
          ),
        );
    await _loadActivityLogs();
  }

  Future<void> updateReviewStatus(
    int questionId,
    DateTime nextReviewDate,
    int reviewStep,
    int? lastReviewInterval,
  ) async {
    await (_db.update(
      _db.savedQuestions,
    )..where((t) => t.id.equals(questionId))).write(
      SavedQuestionsCompanion(
        nextReviewDate: Value(nextReviewDate),
        reviewStep: Value(reviewStep),
        lastReviewInterval: Value(lastReviewInterval),
      ),
    );

    await logActivity(1);

    if (_savedQuestions.any((q) => q.id == questionId)) {
      final folderId = _savedQuestions
          .firstWhere((q) => q.id == questionId)
          .folderId;
      await loadQuestionsByFolder(folderId);
    }
  }

  Future<void> loadQuestionsByFolder(int folderId) async {
    _savedQuestions = await (_db.select(
      _db.savedQuestions,
    )..where((t) => t.folderId.equals(folderId))).get();
    notifyListeners();
  }

  Future<void> saveQuestion({
    required int folderId,
    required String baseUrl,
    required String scraperType,
    required String bookId,
    required String chapterId,
    required String breadcrumbs,
    required Question question,
    String? notes,
  }) async {
    await _db
        .into(_db.savedQuestions)
        .insert(
          SavedQuestionsCompanion.insert(
            folderId: folderId,
            baseUrl: baseUrl,
            scraperType: scraperType,
            bookId: bookId,
            chapterId: chapterId,
            questionId: question.id,
            breadcrumbs: breadcrumbs,
            rawJson: jsonEncode(question.toJson()),
            notes: Value(notes),
          ),
        );

    await logActivity(0);
  }

  Future<void> deleteSavedQuestion(int id, int folderId) async {
    await (_db.delete(_db.savedQuestions)..where((t) => t.id.equals(id))).go();
    await loadQuestionsByFolder(folderId);
    await _loadActivityLogs();
  }

  Future<void> updateQuestionNote(int id, String? newNote, int folderId) async {
    await (_db.update(_db.savedQuestions)..where((t) => t.id.equals(id))).write(
      SavedQuestionsCompanion(notes: Value(newNote)),
    );
    await loadQuestionsByFolder(folderId);
  }

  Future<void> exportData() async {
    final folders = await _db.select(_db.questionFolders).get();
    final questions = await _db.select(_db.savedQuestions).get();
    final logs = await _db.select(_db.reviewLogs).get();

    final exportMap = {
      'version': 1,
      'export_date': DateTime.now().toIso8601String(),
      'folders': folders
          .map(
            (f) => {
              'id': f.id,
              'name': f.name,
              'parentId': f.parentId,
              'createdAt': f.createdAt.toIso8601String(),
            },
          )
          .toList(),
      'questions': questions
          .map(
            (q) => {
              'folderId': q.folderId,
              'baseUrl': q.baseUrl,
              'scraperType': q.scraperType,
              'bookId': q.bookId,
              'chapterId': q.chapterId,
              'questionId': q.questionId,
              'breadcrumbs': q.breadcrumbs,
              'rawJson': q.rawJson,
              'notes': q.notes,
              'savedAt': q.savedAt.toIso8601String(),
              'nextReviewDate': q.nextReviewDate.toIso8601String(),
              'reviewStep': q.reviewStep,
            },
          )
          .toList(),
      'logs': logs
          .map((l) => {'date': l.date.toIso8601String(), 'type': l.type})
          .toList(),
    };

    final jsonString = jsonEncode(exportMap);

    final String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Yedekleme dosyasını kaydet',
      fileName:
          'derspp_savedquestions_${DateTime.now().millisecondsSinceEpoch}.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: utf8.encode(jsonString),
    );

    if (outputFile != null && (Platform.isAndroid || Platform.isIOS)) {
      final file = File(outputFile);
      await file.writeAsString(jsonString);
    }
  }

  Future<bool> importData() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) return false;

    try {
      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      if (data['version'] != 1) throw Exception('Uyumsuz yedekleme versiyonu');

      final List<dynamic> jsonFolders = data['folders'];
      final List<dynamic> jsonQuestions = data['questions'];
      final List<dynamic> jsonLogs = data['logs'];

      final Map<int, int> folderIdMap = {};

      Future<void> addFoldersRecursive(
        int? oldParentId,
        int? newParentId,
      ) async {
        final currentLevel = jsonFolders
            .where((f) => f['parentId'] == oldParentId)
            .toList();
        for (final f in currentLevel) {
          final newId = await _db
              .into(_db.questionFolders)
              .insert(
                QuestionFoldersCompanion.insert(
                  name: f['name'],
                  parentId: Value(newParentId),
                  createdAt: Value(DateTime.parse(f['createdAt'])),
                ),
              );
          folderIdMap[f['id']] = newId;
          await addFoldersRecursive(f['id'], newId);
        }
      }

      await _db.transaction(() async {
        await addFoldersRecursive(null, null);

        for (final q in jsonQuestions) {
          final newFolderId = folderIdMap[q['folderId']];
          if (newFolderId != null) {
            await _db
                .into(_db.savedQuestions)
                .insert(
                  SavedQuestionsCompanion.insert(
                    folderId: newFolderId,
                    baseUrl: q['baseUrl'],
                    scraperType: q['scraperType'],
                    bookId: q['bookId'],
                    chapterId: q['chapterId'],
                    questionId: q['questionId'],
                    breadcrumbs: q['breadcrumbs'],
                    rawJson: q['rawJson'],
                    notes: Value(q['notes']),
                    savedAt: Value(DateTime.parse(q['savedAt'])),
                    nextReviewDate: Value(DateTime.parse(q['nextReviewDate'])),
                    reviewStep: Value(q['reviewStep']),
                  ),
                );
          }
        }

        for (final l in jsonLogs) {
          await _db
              .into(_db.reviewLogs)
              .insert(
                ReviewLogsCompanion.insert(
                  date: Value(DateTime.parse(l['date'])),
                  type: Value(l['type']),
                ),
              );
        }
      });

      await refreshFolders();
      await _loadActivityLogs();
      return true;
    } catch (e) {
      debugPrint('Import hatası: $e');
      return false;
    }
  }
}
