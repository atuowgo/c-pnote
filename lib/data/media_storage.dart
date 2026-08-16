import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;

class SavedVideo {
  const SavedVideo({
    required this.id,
    required this.path,
    required this.thumbPath,
    required this.sizeBytes,
    this.durationMs,
    this.width,
    this.height,
  });

  final String id;
  final String path;
  final String? thumbPath;
  final int sizeBytes;
  final int? durationMs;
  final int? width;
  final int? height;
}

class SavedImage {
  const SavedImage({
    required this.id,
    required this.path,
    required this.thumbPath,
    required this.sizeBytes,
  });

  final String id;
  final String path;
  final String? thumbPath;
  final int sizeBytes;
}

/// 把选择/拍摄的图片压缩后存入 App 私有目录（设计文档 §3.1 媒体处理）。
class MediaStorage {
  static const _uuid = Uuid();

  Future<Directory> _mediaDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'media'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// 在 App 私有媒体目录下分配一个新文件路径（不创建文件），供录音/视频等
  /// 需要"边写边生成路径"的场景使用。
  Future<String> allocatePath(String ext) async {
    final dir = await _mediaDir();
    return p.join(dir.path, '${_uuid.v4()}.$ext');
  }

  /// 把内存字节写入私有媒体目录（用于画板导出的 PNG 等）。
  Future<String> saveBytes(Uint8List bytes, String ext) async {
    final path = await allocatePath(ext);
    await File(path).writeAsBytes(bytes, flush: true);
    return path;
  }

  /// 把已存在于任意路径的文件复制进私有媒体目录（用于拍摄/选择的视频原文件）。
  Future<String> importFile(String sourcePath, String ext) async {
    final target = await allocatePath(ext);
    await File(sourcePath).copy(target);
    return target;
  }

  Future<int> fileSize(String path) async {
    try {
      return await File(path).length();
    } catch (_) {
      return 0;
    }
  }

  /// 保存拍摄/选择的视频：拷贝进私有目录、生成封面帧缩略图、读取时长与分辨率。
  Future<SavedVideo?> saveVideo(String sourcePath) async {
    final dir = await _mediaDir();
    final id = _uuid.v4();
    final srcExt = p.extension(sourcePath).replaceFirst('.', '');
    final ext = srcExt.isNotEmpty ? srcExt : 'mp4';
    final targetPath = p.join(dir.path, '$id.$ext');
    await File(sourcePath).copy(targetPath);

    String? thumbPath;
    try {
      thumbPath = await vt.VideoThumbnail.thumbnailFile(
        video: targetPath,
        thumbnailPath: dir.path,
        imageFormat: vt.ImageFormat.JPEG,
        maxWidth: 480,
        quality: 70,
      );
    } catch (_) {
      thumbPath = null;
    }

    int? durationMs;
    int? width;
    int? height;
    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.file(File(targetPath));
      await controller.initialize();
      durationMs = controller.value.duration.inMilliseconds;
      width = controller.value.size.width.round();
      height = controller.value.size.height.round();
    } catch (_) {
      // 拿不到元数据时留空，不影响保存
    } finally {
      await controller?.dispose();
    }

    final size = await File(targetPath).length();
    return SavedVideo(
      id: id,
      path: targetPath,
      thumbPath: thumbPath,
      sizeBytes: size,
      durationMs: durationMs,
      width: width,
      height: height,
    );
  }

  /// 删除媒体文件（用于回收站彻底删除），忽略不存在的情况。
  Future<void> deleteFile(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {
      // 忽略删除失败（例如文件已不存在）
    }
  }

  Future<SavedImage?> saveImage(String sourcePath) async {
    final dir = await _mediaDir();
    final id = _uuid.v4();
    final targetPath = p.join(dir.path, '$id.jpg');
    final thumbPath = p.join(dir.path, '${id}_thumb.jpg');

    final full = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      minWidth: 2048,
      minHeight: 2048,
      quality: 85,
    );
    if (full == null) return null;

    final thumb = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      thumbPath,
      minWidth: 480,
      minHeight: 480,
      quality: 70,
    );

    final size = await File(full.path).length();
    return SavedImage(
      id: id,
      path: full.path,
      thumbPath: thumb?.path,
      sizeBytes: size,
    );
  }
}
