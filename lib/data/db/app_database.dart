import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// 日记表 —— 对应设计文档 §5.1 diary
@DataClassName('Diary')
class Diaries extends Table {
  TextColumn get id => text()();

  /// 归属日期（用于按天分组，规整到当天 00:00）
  DateTimeColumn get entryDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  TextColumn get title => text().nullable()();

  /// M1：正文以纯文本存储；后续里程碑扩展为块结构 JSON
  TextColumn get body => text().withDefault(const Constant(''))();

  TextColumn get mood => text().nullable()();
  TextColumn get weather => text().nullable()();
  TextColumn get temperature => text().nullable()();
  TextColumn get locationName => text().nullable()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get device => text().nullable()();

  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get syncRev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 媒体表 —— 对应设计文档 §5.1 media_asset
@DataClassName('MediaAsset')
class MediaAssets extends Table {
  TextColumn get id => text()();
  TextColumn get diaryId => text().references(Diaries, #id)();

  /// image / audio / video / sketch
  TextColumn get type => text()();
  TextColumn get localPath => text()();
  TextColumn get thumbPath => text().nullable()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get sizeBytes => integer().nullable()();
  TextColumn get caption => text().nullable()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Diaries, MediaAssets])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  // ---------------- 查询 ----------------

  /// 时间线：按 entryDate、createdAt 倒序，附带媒体
  Stream<List<Diary>> watchDiaries() {
    final q = select(diaries)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([
        (t) => OrderingTerm(expression: t.entryDate, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    return q.watch();
  }

  Stream<List<MediaAsset>> watchMediaFor(List<String> diaryIds) {
    if (diaryIds.isEmpty) {
      return Stream.value(const []);
    }
    final q = select(mediaAssets)
      ..where((m) => m.diaryId.isIn(diaryIds))
      ..orderBy([(m) => OrderingTerm(expression: m.orderIndex)]);
    return q.watch();
  }

  Future<List<MediaAsset>> mediaFor(String diaryId) {
    final q = select(mediaAssets)
      ..where((m) => m.diaryId.equals(diaryId))
      ..orderBy([(m) => OrderingTerm(expression: m.orderIndex)]);
    return q.get();
  }

  Future<Diary?> findDiary(String id) {
    return (select(diaries)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsertDiary(DiariesCompanion entry) {
    return into(diaries).insertOnConflictUpdate(entry);
  }

  Future<void> replaceMedia(String diaryId, List<MediaAssetsCompanion> items) {
    return transaction(() async {
      await (delete(mediaAssets)..where((m) => m.diaryId.equals(diaryId))).go();
      for (final m in items) {
        await into(mediaAssets).insert(m);
      }
    });
  }

  Future<void> softDelete(String id) {
    return (update(diaries)..where((t) => t.id.equals(id))).write(
      DiariesCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setFavorite(String id, bool value) {
    return (update(diaries)..where((t) => t.id.equals(id))).write(
      DiariesCompanion(
        isFavorite: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pnote.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
