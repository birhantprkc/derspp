import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';

class SubjectReviewProvider extends ChangeNotifier {
  final AppDatabase _db;
  List<StudySubject> _subjects = [];

  SubjectReviewProvider(this._db) {
    loadSubjects();
  }

  List<StudySubject> get subjects => _subjects;

  Future<void> loadSubjects() async {
    _subjects = await _db.select(_db.studySubjects).get();
    notifyListeners();
  }

  List<StudySubject> getChildren(int? parentId) {
    return _subjects.where((s) => s.parentId == parentId).toList();
  }

  Future<void> addSubject(
    String name,
    int? parentId,
    bool isLeaf, {
    int? syncFolderId,
  }) async {
    await _db
        .into(_db.studySubjects)
        .insert(
          StudySubjectsCompanion.insert(
            name: name,
            parentId: Value(parentId),
            isLeaf: Value(isLeaf),
            syncWithFolderId: Value(syncFolderId),
          ),
        );
    await loadSubjects();
  }

  Future<void> updateSubject(int id, {String? name, int? syncFolderId}) async {
    await (_db.update(_db.studySubjects)..where((t) => t.id.equals(id))).write(
      StudySubjectsCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        syncWithFolderId: syncFolderId != null
            ? Value(syncFolderId)
            : const Value.absent(),
      ),
    );
    await loadSubjects();
  }

  Future<void> deleteSubject(int id) async {
    final allIds = _getAllIdsRecursive(id);
    await (_db.delete(_db.studySubjects)..where((t) => t.id.isIn(allIds))).go();
    await loadSubjects();
  }

  List<int> _getAllIdsRecursive(int id) {
    final ids = <int>[id];
    final children = _subjects.where((s) => s.parentId == id).toList();
    for (final child in children) {
      ids.addAll(_getAllIdsRecursive(child.id));
    }
    return ids;
  }

  Future<void> markAsKnown(int id, int intervalDays) async {
    final nextDate = DateTime.now().add(Duration(days: intervalDays));
    await (_db.update(_db.studySubjects)..where((t) => t.id.equals(id))).write(
      StudySubjectsCompanion(
        isKnown: const Value(true),
        nextReviewDate: Value(nextDate),
        lastReviewInterval: Value(intervalDays),
      ),
    );
    await loadSubjects();
  }

  Future<void> resetKnown(int id) async {
    await (_db.update(_db.studySubjects)..where((t) => t.id.equals(id))).write(
      const StudySubjectsCompanion(
        isKnown: Value(false),
        nextReviewDate: Value(null),
        lastReviewInterval: Value(null),
      ),
    );
    await loadSubjects();
  }

  double calculateProgress(int id) {
    final node = _subjects.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Ders bulunamadı.'),
    );
    return _calculateProgressRecursive(node);
  }

  double _calculateProgressRecursive(StudySubject node) {
    if (node.isLeaf) {
      if (!node.isKnown) return 0.0;
      if (node.nextReviewDate != null &&
          node.nextReviewDate!.isBefore(DateTime.now())) {
        return 0.0;
      }
      return 1.0;
    }

    final children = getChildren(node.id);
    if (children.isEmpty) return 0.0;

    double totalProgress = 0;
    for (final child in children) {
      totalProgress += _calculateProgressRecursive(child);
    }
    return totalProgress / children.length;
  }

  List<StudySubject> get dueSubjects {
    return _subjects.where((s) =>
        s.isLeaf &&
        s.isKnown &&
        s.nextReviewDate != null &&
        s.nextReviewDate!.isBefore(DateTime.now())).toList();
  }

  List<StudySubject> get upcomingSubjects {
    final now = DateTime.now();
    final list = _subjects.where((s) =>
        s.isLeaf &&
        s.isKnown &&
        s.nextReviewDate != null &&
        s.nextReviewDate!.isAfter(now)).toList();
    list.sort((a, b) => a.nextReviewDate!.compareTo(b.nextReviewDate!));
    return list;
  }

  int getDueCount(int id) {
    final node = _subjects.firstWhere((s) => s.id == id);
    return _getDueCountRecursive(node);
  }

  int _getDueCountRecursive(StudySubject node) {
    if (node.isLeaf) {
      if (node.isKnown &&
          node.nextReviewDate != null &&
          node.nextReviewDate!.isBefore(DateTime.now())) {
        return 1;
      }
      return 0;
    }

    final children = getChildren(node.id);
    int count = 0;
    for (final child in children) {
      count += _getDueCountRecursive(child);
    }
    return count;
  }
}
