import 'package:collection/collection.dart';

import '../domain/diary_entry.dart';
import 'db/app_database.dart';

/// 日记仓储：包裹数据库，向上层提供聚合后的领域数据。
class DiaryRepository {
  DiaryRepository(this._db);

  final AppDatabase _db;

  /// 时间线：日记 + 媒体的聚合流（按日期倒序）。
  Stream<List<DiaryEntry>> watchEntries() {
    return _db.watchDiaries().asyncMap((rows) async {
      if (rows.isEmpty) return const <DiaryEntry>[];
      final ids = rows.map((r) => r.id).toList();
      final media = await _db.watchMediaFor(ids).first;
      final byDiary = groupBy(media, (MediaAsset m) => m.diaryId);
      return rows
          .map((r) => DiaryEntry(r, byDiary[r.id] ?? const []))
          .toList(growable: false);
    });
  }

  Future<DiaryEntry?> getEntry(String id) async {
    final diary = await _db.findDiary(id);
    if (diary == null) return null;
    final media = await _db.mediaFor(id);
    return DiaryEntry(diary, media);
  }

  Future<void> saveEntry({
    required DiariesCompanion diary,
    required List<MediaAssetsCompanion> media,
  }) async {
    await _db.upsertDiary(diary);
    await _db.replaceMedia(diary.id.value, media);
  }

  Future<void> delete(String id) => _db.softDelete(id);

  Future<void> setFavorite(String id, bool value) =>
      _db.setFavorite(id, value);
}

/// 把扁平的 entry 列表按天分组（用于时间线渲染）。
List<DaySection> groupByDay(List<DiaryEntry> entries) {
  final grouped = groupBy(
    entries,
    (DiaryEntry e) => DateTime(
      e.diary.entryDate.year,
      e.diary.entryDate.month,
      e.diary.entryDate.day,
    ),
  );
  final sections = grouped.entries
      .map((e) => DaySection(e.key, e.value))
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
  return sections;
}

/// 历史上的今天：与今天同月日、但年份更早的日记。
List<DiaryEntry> onThisDay(List<DiaryEntry> entries, DateTime today) {
  return entries
      .where((e) =>
          e.diary.entryDate.month == today.month &&
          e.diary.entryDate.day == today.day &&
          e.diary.entryDate.year < today.year)
      .toList(growable: false)
    ..sort((a, b) => b.diary.entryDate.compareTo(a.diary.entryDate));
}
