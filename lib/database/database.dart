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

@DriftDatabase(tables: [Books, Publishers, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'derspp_v2',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
