import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../domain/diary_entry.dart';
import '../../providers.dart';

/// 回收站：列出软删除的日记，支持恢复 / 彻底删除。
class TrashPage extends ConsumerWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final trashAsync = ref.watch(trashEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('回收站')),
      body: trashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_outline, size: 52, color: palette.subtle),
                  const SizedBox(height: 14),
                  Text('回收站是空的',
                      style: TextStyle(color: palette.subtle, fontSize: 15)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            itemCount: entries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _TrashCard(entry: entries[i]),
          );
        },
      ),
    );
  }
}

class _TrashCard extends ConsumerWidget {
  const _TrashCard({required this.entry});
  final DiaryEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final d = entry.diary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 13, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${Fmt.monthDay(d.entryDate)} · ${Fmt.weekday(d.entryDate)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            if (d.body.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                d.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.5, color: palette.subtle, height: 1.5),
              ),
            ],
            if (d.deletedAt != null) ...[
              const SizedBox(height: 6),
              Text('删除于 ${Fmt.ymdSlash(d.deletedAt!)}',
                  style: TextStyle(fontSize: 11.5, color: palette.subtle)),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () =>
                      ref.read(diaryRepositoryProvider).restore(d.id),
                  icon: const Icon(Icons.restore, size: 18),
                  label: const Text('恢复'),
                ),
                TextButton.icon(
                  onPressed: () => _confirmHardDelete(context, ref, d.id),
                  icon: Icon(Icons.delete_forever,
                      size: 18, color: Colors.red.shade400),
                  label: Text('彻底删除',
                      style: TextStyle(color: Colors.red.shade400)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmHardDelete(
      BuildContext context, WidgetRef ref, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('彻底删除'),
        content: const Text('将永久删除这篇日记及其所有媒体文件，且无法恢复。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('彻底删除')),
        ],
      ),
    );
    if (ok == true) {
      await ref
          .read(diaryRepositoryProvider)
          .hardDelete(id, ref.read(mediaStorageProvider));
    }
  }
}
