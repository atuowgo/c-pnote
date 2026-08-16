import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/diary_repository.dart';
import '../../domain/diary_entry.dart';
import '../../providers.dart';
import '../detail/detail_page.dart';
import '../editor/editor_page.dart';
import '../gallery/gallery_page.dart';
import '../calendar/calendar_page.dart';
import '../settings/settings_page.dart';
import '../trash/trash_page.dart';
import '../widgets/audio_player_tile.dart';
import '../widgets/local_image.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(entriesProvider);
    final palette = Theme.of(context).extension<AppPalette>()!;

    return Scaffold(
      drawer: const _AppDrawer(),
      appBar: AppBar(
        backgroundColor: palette.warm,
        titleSpacing: 0,
        title: Row(
          children: [
            Text(Fmt.monthDay(DateTime.now()),
                style: const TextStyle(fontWeight: FontWeight.w700)),
            const Icon(Icons.expand_more, size: 20),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _todo(context, '搜索'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => _todo(context, '书签'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _todo(context, '更多'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context),
        tooltip: '写日记',
        child: const Icon(Icons.edit_outlined),
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (entries) {
          if (entries.isEmpty) return const _EmptyState();
          final sections = groupByDay(entries);
          final onToday = onThisDay(entries, DateTime.now());
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              if (onToday.isNotEmpty) _OnThisDayStrip(entries: onToday),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text('— 共 ${entries.length} 篇 —',
                      style: TextStyle(color: palette.subtle, fontSize: 12.5)),
                ),
              ),
              for (final s in sections) _DaySectionView(section: s),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openEditor(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditorPage()),
    );
  }

  void _todo(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label（后续里程碑）')),
    );
  }
}

class _DaySectionView extends StatelessWidget {
  const _DaySectionView({required this.section});
  final DaySection section;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${section.date.day}',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 1)),
                const SizedBox(height: 4),
                Text('${section.date.month}月 / ${Fmt.weekday(section.date)}',
                    style: TextStyle(fontSize: 11, color: palette.subtle)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                for (final e in section.entries) ...[
                  _EntryCard(entry: e),
                  if (e != section.entries.last) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});
  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    final d = entry.diary;
    final images = entry.images;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DetailPage(entryId: d.id)),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((d.title ?? '').isNotEmpty) ...[
                Text(d.title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 6),
              ],
              if (d.body.isNotEmpty)
                Text(
                  d.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14.5, height: 1.6),
                ),
              if (images.isNotEmpty) ...[
                const SizedBox(height: 11),
                LocalImage(
                  path: images.first.thumbPath ?? images.first.localPath,
                  width: 88,
                  height: 88,
                ),
              ],
              if (entry.hasAudio) ...[
                const SizedBox(height: 11),
                AudioPlayerTile(
                  path: entry.audios.first.localPath,
                  durationMs: entry.audios.first.durationMs,
                  compact: true,
                ),
              ],
              const SizedBox(height: 12),
              _MetaRow(entry: entry),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.entry});
  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final d = entry.diary;
    final style = TextStyle(fontSize: 12, color: palette.subtle);
    final parts = <Widget>[
      Icon(Icons.schedule, size: 13, color: palette.subtle),
      const SizedBox(width: 4),
      Text(Fmt.hm(d.createdAt), style: style),
    ];
    if ((d.weather ?? '').isNotEmpty) {
      parts.add(Text(' · ${d.weather}', style: style));
    }
    if (entry.hasAudio) {
      parts.addAll([const SizedBox(width: 8), Icon(Icons.mic, size: 13, color: palette.subtle)]);
    }
    return Row(
      children: [
        ...parts,
        const Spacer(),
        if ((d.locationName ?? '').isNotEmpty) ...[
          Icon(Icons.place_outlined, size: 13, color: palette.subtle),
          const SizedBox(width: 2),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130),
            child: Text(d.locationName!,
                overflow: TextOverflow.ellipsis, style: style),
          ),
        ],
      ],
    );
  }
}

class _OnThisDayStrip extends StatelessWidget {
  const _OnThisDayStrip({required this.entries});
  final List<DiaryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final now = DateTime.now();
    return Container(
      color: palette.warm,
      padding: const EdgeInsets.only(top: 4, bottom: 14),
      child: SizedBox(
        height: 150,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: entries.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final e = entries[i];
            final img = e.images.isNotEmpty
                ? (e.images.first.thumbPath ?? e.images.first.localPath)
                : null;
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => DetailPage(entryId: e.diary.id)),
              ),
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: palette.subtle.withValues(alpha: 0.25),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (img != null)
                      LocalImage(path: img, radius: 16, fit: BoxFit.cover),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black12, Colors.black87],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Fmt.yearsAgo(e.diary.entryDate, now),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Text(Fmt.ymdSlash(e.diary.entryDate),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 3),
                          Text(
                            e.diary.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories_outlined, size: 56, color: palette.subtle),
          const SizedBox(height: 16),
          Text('还没有日记', style: TextStyle(fontSize: 16, color: palette.subtle)),
          const SizedBox(height: 6),
          Text('点右下角羽毛笔，记录今日',
              style: TextStyle(fontSize: 13, color: palette.subtle)),
        ],
      ),
    );
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final count = ref.watch(entriesProvider).valueOrNull?.length ?? 0;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: double.infinity,
              color: palette.warm,
              alignment: Alignment.center,
              child: const Text('🎈', style: TextStyle(fontSize: 40)),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: Text('账号信息',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            _DrawerItem(
                icon: Icons.pie_chart_outline,
                label: '统计',
                trailing: '共 $count 篇',
                onTap: () => _soon(context)),
            _DrawerItem(
                icon: Icons.photo_library_outlined,
                label: '图库',
                onTap: () => _push(context, const GalleryPage())),
            _DrawerItem(
                icon: Icons.calendar_today_outlined,
                label: '日历',
                onTap: () => _push(context, const CalendarPage())),
            _DrawerItem(
                icon: Icons.explore_outlined,
                label: '漫步',
                onTap: () => _walk(context, ref)),
            _DrawerItem(
                icon: Icons.auto_awesome_outlined,
                label: 'AI 助手',
                onTap: () => _soon(context)),
            const Divider(height: 20),
            _DrawerItem(
                icon: Icons.settings_outlined,
                label: '设置',
                onTap: () => _push(context, const SettingsPage())),
            _DrawerItem(
                icon: Icons.delete_outline,
                label: '回收站',
                onTap: () => _push(context, const TrashPage())),
          ],
        ),
      ),
    );
  }

  void _soon(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('该功能将在后续里程碑上线')));
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page));
  }

  void _walk(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    final entries = ref.read(entriesProvider).valueOrNull ?? const [];
    if (entries.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('还没有日记可以漫步')));
      return;
    }
    final entry = entries[Random().nextInt(entries.length)];
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailPage(entryId: entry.diary.id)),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    return ListTile(
      leading: Icon(icon, color: palette.subtle),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      trailing: trailing == null
          ? null
          : Text(trailing!,
              style: TextStyle(fontSize: 12.5, color: palette.subtle)),
      onTap: onTap,
    );
  }
}
