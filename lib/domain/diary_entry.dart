import '../data/db/app_database.dart';

/// 一条日记及其媒体的聚合视图（供 UI 使用）
class DiaryEntry {
  const DiaryEntry(this.diary, this.media);

  final Diary diary;
  final List<MediaAsset> media;

  List<MediaAsset> get images =>
      media.where((m) => m.type == 'image').toList(growable: false);

  bool get hasAudio => media.any((m) => m.type == 'audio');
  bool get hasVideo => media.any((m) => m.type == 'video');
}

/// 按天分组的时间线分区
class DaySection {
  DaySection(this.date, this.entries);

  final DateTime date;
  final List<DiaryEntry> entries;
}
