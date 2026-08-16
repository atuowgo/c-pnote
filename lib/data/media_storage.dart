import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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
