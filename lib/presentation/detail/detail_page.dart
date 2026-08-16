import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../domain/diary_entry.dart';
import '../../providers.dart';
import '../editor/editor_page.dart';
import '../widgets/local_image.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({super.key, required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEntry = ref.watch(entryProvider(entryId));
    return Scaffold(
      body: asyncEntry.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (entry) {
          if (entry == null) {
            return const Center(child: Text('日记不存在或已删除'));
          }
          return _DetailView(entry: entry);
        },
      ),
    );
  }
}

class _DetailView extends ConsumerWidget {
  const _DetailView({required this.entry});
  final DiaryEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final d = entry.diary;
    final images = entry.images;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: images.isNotEmpty ? 240 : 0,
          actions: [
            IconButton(
              icon: Icon(d.isFavorite ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () =>
                  ref.read(diaryRepositoryProvider).setFavorite(d.id, !d.isFavorite),
            ),
            PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'edit') {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EditorPage(entryId: d.id)));
                } else if (v == 'delete') {
                  await _confirmDelete(context, ref, d.id);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('编辑')),
                PopupMenuItem(value: 'delete', child: Text('删除')),
              ],
            ),
          ],
          flexibleSpace: images.isNotEmpty
              ? FlexibleSpaceBar(
                  background: LocalImage(
                    path: images.first.localPath,
                    radius: 0,
                    fit: BoxFit.cover,
                  ),
                )
              : null,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${Fmt.monthDay(d.entryDate)} · ${Fmt.weekday(d.entryDate)}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    _meta(Icons.schedule, Fmt.hm(d.createdAt), palette),
                    if ((d.weather ?? '').isNotEmpty)
                      _meta(Icons.wb_cloudy_outlined, d.weather!, palette),
                    if ((d.locationName ?? '').isNotEmpty)
                      _meta(Icons.place_outlined, d.locationName!, palette),
                    if ((d.mood ?? '').isNotEmpty)
                      Text(d.mood!, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 18),
                if ((d.title ?? '').isNotEmpty) ...[
                  Text(d.title!,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                ],
                if (d.body.isNotEmpty)
                  Text(d.body,
                      style: const TextStyle(fontSize: 15.5, height: 1.85)),
                if (images.length > 1) ...[
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in images.skip(1))
                        LocalImage(
                            path: m.thumbPath ?? m.localPath,
                            width: 104,
                            height: 104),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _meta(IconData icon, String text, AppPalette palette) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: palette.subtle),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12.5, color: palette.subtle)),
      ],
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除日记'),
        content: const Text('删除后会进入回收站，可在回收站恢复。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('删除')),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(diaryRepositoryProvider).delete(id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}
