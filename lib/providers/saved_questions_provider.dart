import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../database/database.dart';
import '../models/question.dart';

class SavedQuestionsProvider extends ChangeNotifier {
  final AppDatabase _db;
  List<QuestionFolder> _folders = [];
  List<SavedQuestion> _savedQuestions = [];

  SavedQuestionsProvider(this._db) {
    refreshFolders();
  }

  List<QuestionFolder> get folders => _folders;
  List<SavedQuestion> get savedQuestions => _savedQuestions;

  // --- Klasör İşlemleri ---

  Future<void> refreshFolders() async {
    _folders = await _db.select(_db.questionFolders).get();
    notifyListeners();
  }

  Future<int> createFolder(String name) async {
    final id = await _db
        .into(_db.questionFolders)
        .insert(QuestionFoldersCompanion.insert(name: name));
    await refreshFolders();
    return id;
  }

  Future<void> deleteFolder(int id) async {
    await (_db.delete(
      _db.savedQuestions,
    )..where((t) => t.folderId.equals(id))).go();
    await (_db.delete(_db.questionFolders)..where((t) => t.id.equals(id))).go();
    await refreshFolders();
  }

  // --- Soru İşlemleri ---

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
          ),
        );
  }

  Future<void> deleteSavedQuestion(int id) async {
    await (_db.delete(_db.savedQuestions)..where((t) => t.id.equals(id))).go();
  }
}
