import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Books extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get sourceId => text()();
  TextColumn get baseUrl => text()();
  DateTimeColumn get addedDate => dateTime()();
  TextColumn get coverImage => text().nullable()();
  TextColumn get originalCoverImage => text().nullable()();

  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get scraperType => text().withDefault(const Constant('fsource'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Publishers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get url => text()();
  TextColumn get sourceId => text()();
  TextColumn get scraperType => text().withDefault(const Constant('fsource'))();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

class QuestionFolders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get parentId =>
      integer().nullable().references(QuestionFolders, #id)();
}

class SavedQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get folderId => integer().references(QuestionFolders, #id)();
  TextColumn get baseUrl => text()();
  TextColumn get scraperType => text()();
  TextColumn get bookId => text()();
  TextColumn get chapterId => text()();
  TextColumn get questionId => text()();
  TextColumn get breadcrumbs => text()();
  TextColumn get rawJson => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get nextReviewDate =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get reviewStep => integer().withDefault(const Constant(0))();
}

class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  IntColumn get type => integer().withDefault(const Constant(0))();
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get dayIndex => integer()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime().nullable()();
  DateTimeColumn get startDate => dateTime().withDefault(currentDateAndTime)();
  IntColumn get frequency => integer().withDefault(const Constant(0))();
}

class RoutineCompletions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId => integer().references(Tasks, #id)();
  DateTimeColumn get date => dateTime()();
}

@DriftDatabase(
  tables: [
    Books,
    Publishers,
    Settings,
    QuestionFolders,
    SavedQuestions,
    ReviewLogs,
    Tasks,
    RoutineCompletions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(questionFolders);
          await m.createTable(savedQuestions);
          await m.addColumn(savedQuestions, savedQuestions.nextReviewDate);
          await m.addColumn(savedQuestions, savedQuestions.reviewStep);
          await m.addColumn(questionFolders, questionFolders.parentId);
          await m.createTable(reviewLogs);
          await m.addColumn(savedQuestions, savedQuestions.notes);
          await m.addColumn(reviewLogs, reviewLogs.type);
        }
        if (from < 3) {
          await m.createTable(tasks);
          await m.createTable(routineCompletions);
          await m.addColumn(tasks, tasks.startDate);
          await m.addColumn(tasks, tasks.frequency);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'derspp',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
