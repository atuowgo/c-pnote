import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/db/app_database.dart';
import '../../providers.dart';
import '../detail/detail_page.dart';
import '../widgets/local_image.dart';

/// 图库墙：九宫格展示全部图片/视频/画板，点击回到所属日记详情。
class GalleryPage extends ConsumerWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final mediaAsync = ref.watch(galleryMediaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('图库')),
      body: mediaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (all) {
          final visual =
              all.where((m) => m.type != 'audio').toList(growable: false);
          if (visual.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library_outlined,
                      size: 52, color: palette.subtle),
                  const SizedBox(height: 14),
                  Text('还没有图片或视频',
                      style: TextStyle(color: palette.subtle, fontSize: 15)),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(3),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemCount: visual.length,
            itemBuilder: (_, i) => _GalleryTile(asset: visual[i]),
          );
        },
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({required this.asset});
  final MediaAsset asset;

  @override
  Widget build(BuildContext context) {
    final thumb = asset.thumbPath ?? asset.localPath;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DetailPage(entryId: asset.diaryId)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          LocalImage(path: thumb, radius: 0, fit: BoxFit.cover),
          if (asset.type == 'video')
            const ColoredBox(
              color: Colors.black26,
              child: Icon(Icons.play_circle_fill,
                  color: Colors.white, size: 30),
            ),
        ],
      ),
    );
  }
}
