import 'package:flutter/material.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart';

class TaskProvider with ChangeNotifier {
  final AppDatabase _db;
  List<Task> _tasks = [];
  List<RoutineCompletion> _routineCompletions = [];
  DateTime _focusedDate = DateTime.now();

  TaskProvider(this._db) {
    _fetchTasks();
    _fetchRoutineCompletions();
  }

  List<Task> get tasks => _tasks;
  DateTime get focusedDate => _focusedDate;

  DateTime get weekStart {
    int daysToSubtract = _focusedDate.weekday - 1;
    return DateTime(
      _focusedDate.year,
      _focusedDate.month,
      _focusedDate.day,
    ).subtract(Duration(days: daysToSubtract));
  }

  DateTime get weekEnd => weekStart.add(const Duration(days: 6));

  int get weekNumber {
    DateTime date = _focusedDate;
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) woy = 52;
    return woy;
  }

  String get weekRangeText {
    final start = weekStart;
    final end = weekEnd;
    final DateFormat formatter = DateFormat("d MMM", "tr_TR");
    return "${formatter.format(start)} - ${formatter.format(end)}";
  }

  bool get isCurrentWeek {
    final now = DateTime.now();
    final nowWeekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    return weekStart.isAtSameMomentAs(nowWeekStart);
  }

  bool get isPastWeek {
    final now = DateTime.now();
    final nowWeekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    return weekStart.isBefore(nowWeekStart);
  }

  bool get isFutureWeek {
    final now = DateTime.now();
    final nowWeekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    return weekStart.isAfter(nowWeekStart);
  }

  void changeWeek(int weeks) {
    _focusedDate = _focusedDate.add(Duration(days: weeks * 7));
    notifyListeners();
  }

  void _fetchTasks() {
    _db.select(_db.tasks).watch().listen((event) {
      _tasks = event;
      notifyListeners();
    });
  }

  void _fetchRoutineCompletions() {
    _db.select(_db.routineCompletions).watch().listen((event) {
      _routineCompletions = event;
      notifyListeners();
    });
  }

  List<Task> getTasksForDay(int dayIndex, String category) {
    final targetDate = weekStart.add(Duration(days: dayIndex));
    final normalizedTarget = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    return _tasks
        .where((t) {
          if (t.category != category || t.dayIndex != dayIndex) return false;

          final normalizedStart = DateTime(
            t.startDate.year,
            t.startDate.month,
            t.startDate.day,
          );

          if (normalizedTarget.isBefore(normalizedStart)) return false;

          if (t.endDate != null) {
            final normalizedEnd = DateTime(
              t.endDate!.year,
              t.endDate!.month,
              t.endDate!.day,
            );
            if (normalizedTarget.isAfter(normalizedEnd)) return false;
          }

          if (t.frequency == 0) {
            if (t.date == null) return false;
            final normalizedTaskDate = DateTime(
              t.date!.year,
              t.date!.month,
              t.date!.day,
            );
            return normalizedTaskDate.isAtSameMomentAs(normalizedTarget);
          }

          final diffDays = normalizedTarget.difference(normalizedStart).inDays;
          final diffWeeks = (diffDays / 7).floor();

          if (t.frequency == 1) return true;
          if (t.frequency == 2) return diffWeeks % 2 == 0;
          if (t.frequency == 4) return diffWeeks % 4 == 0;

          return false;
        })
        .map((t) {
          if (t.frequency != 0) {
            bool isDone = _routineCompletions.any(
              (c) =>
                  c.taskId == t.id &&
                  c.date.year == normalizedTarget.year &&
                  c.date.month == normalizedTarget.month &&
                  c.date.day == normalizedTarget.day,
            );
            return t.copyWith(isDone: isDone);
          }
          return t;
        })
        .toList();
  }

  Future<void> addTask(
    String title,
    int dayIndex,
    String category, {
    int frequency = 0,
  }) async {
    final targetDay = weekStart.add(Duration(days: dayIndex));
    final normalizedTarget =
        DateTime(targetDay.year, targetDay.month, targetDay.day);

    final taskDate = frequency == 0 ? normalizedTarget : null;

    await _db
        .into(_db.tasks)
        .insert(
          TasksCompanion.insert(
            title: title,
            dayIndex: dayIndex,
            category: category,
            date: Value(taskDate),
            startDate: Value(normalizedTarget),
            frequency: Value(frequency),
          ),
        );
  }

  Future<void> toggleTask(Task task) async {
    final targetDate = weekStart.add(Duration(days: task.dayIndex));
    final normalizedTarget = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    if (task.frequency != 0) {
      final existing = _routineCompletions.cast<RoutineCompletion?>().firstWhere(
        (c) =>
            c?.taskId == task.id &&
            c?.date.year == normalizedTarget.year &&
            c?.date.month == normalizedTarget.month &&
            c?.date.day == normalizedTarget.day,
        orElse: () => null,
      );

      if (existing != null) {
        await (_db.delete(_db.routineCompletions)
              ..where((c) => c.id.equals(existing.id)))
            .go();
      } else {
        await _db
            .into(_db.routineCompletions)
            .insert(
              RoutineCompletionsCompanion.insert(
                taskId: task.id,
                date: normalizedTarget,
              ),
            );
      }
    } else {
      await _db.update(_db.tasks).replace(task.copyWith(isDone: !task.isDone));
    }
  }

  Future<void> deleteTask(int id) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) return;
    final task = _tasks[taskIndex];

    if (task.frequency != 0) {
      final newEndDate = weekStart.subtract(const Duration(days: 1));
      await (_db.update(_db.tasks)..where((t) => t.id.equals(id)))
          .write(TasksCompanion(endDate: Value(newEndDate)));
    } else {
      await (_db.delete(_db.routineCompletions)..where((c) => c.taskId.equals(id)))
          .go();
      await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
    }
  }

  Map<DateTime, int> getHeatmapData() {
    Map<DateTime, int> data = {};

    for (var task in _tasks) {
      if (task.isDone && task.date != null) {
        final date = DateTime(
          task.date!.year,
          task.date!.month,
          task.date!.day,
        );
        data[date] = (data[date] ?? 0) + 1;
      }
    }

    for (var comp in _routineCompletions) {
      final date = DateTime(comp.date.year, comp.date.month, comp.date.day);
      data[date] = (data[date] ?? 0) + 1;
    }

    return data;
  }
}
