import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/db/app_database.dart';
import 'data/diary_repository.dart';
import 'data/media_storage.dart';
import 'domain/diary_entry.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository(ref.watch(appDatabaseProvider));
});

final mediaStorageProvider = Provider<MediaStorage>((ref) => MediaStorage());

/// 时间线数据流（全部未删除日记 + 媒体）。
final entriesProvider = StreamProvider<List<DiaryEntry>>((ref) {
  return ref.watch(diaryRepositoryProvider).watchEntries();
});

/// 按天分组后的时间线分区。
final daySectionsProvider = Provider<List<DaySection>>((ref) {
  final entries = ref.watch(entriesProvider).valueOrNull ?? const [];
  return groupByDay(entries);
});

/// 历史上的今天。
final onThisDayProvider = Provider<List<DiaryEntry>>((ref) {
  final entries = ref.watch(entriesProvider).valueOrNull ?? const [];
  return onThisDay(entries, DateTime.now());
});

/// 单条日记详情。
final entryProvider =
    FutureProvider.family<DiaryEntry?, String>((ref, id) async {
  // 依赖时间线流以在数据变化时刷新
  ref.watch(entriesProvider);
  return ref.watch(diaryRepositoryProvider).getEntry(id);
});

/// 回收站（已软删除的日记）。
final trashEntriesProvider = StreamProvider<List<DiaryEntry>>((ref) {
  return ref.watch(diaryRepositoryProvider).watchTrash();
});

/// 图库墙：全部媒体（图片/视频/录音/画板）。
final galleryMediaProvider = StreamProvider<List<MediaAsset>>((ref) {
  return ref.watch(diaryRepositoryProvider).watchAllMedia();
});
