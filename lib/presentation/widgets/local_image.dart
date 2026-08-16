import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// 从本地文件渲染图片，带圆角与失败占位。
class LocalImage extends StatelessWidget {
  const LocalImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.radius = 10,
    this.fit = BoxFit.cover,
  });

  final String path;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => Container(
          width: width,
          height: height,
          color: palette.warm,
          alignment: Alignment.center,
          child: Icon(Icons.broken_image_outlined,
              color: palette.subtle, size: 22),
        ),
      ),
    );
  }
}
