import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/theme.dart';
import 'local_image.dart';

/// 内联视频播放：点击缩略图后就地加载并播放。
class VideoPlayerTile extends StatefulWidget {
  const VideoPlayerTile({
    super.key,
    required this.path,
    this.thumbPath,
    this.width,
    this.height,
    this.radius = 14,
  });

  final String path;
  final String? thumbPath;
  final int? width;
  final int? height;
  final double radius;

  @override
  State<VideoPlayerTile> createState() => _VideoPlayerTileState();
}

class _VideoPlayerTileState extends State<VideoPlayerTile> {
  VideoPlayerController? _controller;
  bool _initializing = false;
  bool _failed = false;

  Future<void> _start() async {
    if (_controller != null || _initializing) return;
    setState(() => _initializing = true);
    try {
      final c = VideoPlayerController.file(File(widget.path));
      await c.initialize();
      if (!mounted) {
        await c.dispose();
        return;
      }
      await c.play();
      c.addListener(_onTick);
      setState(() {
        _controller = c;
        _initializing = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _failed = true;
          _initializing = false;
        });
      }
    }
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTick);
    _controller?.dispose();
    super.dispose();
  }

  double get _aspect {
    final c = _controller;
    if (c != null && c.value.isInitialized && c.value.aspectRatio > 0) {
      return c.value.aspectRatio;
    }
    final w = widget.width;
    final h = widget.height;
    if (w != null && h != null && h > 0) return w / h;
    return 16 / 9;
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final c = _controller;

    if (c != null && c.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: AspectRatio(
          aspectRatio: _aspect,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              VideoPlayer(c),
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(
                      () => c.value.isPlaying ? c.pause() : c.play()),
                  child: AnimatedOpacity(
                    opacity: c.value.isPlaying ? 0 : 1,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      color: Colors.black26,
                      alignment: Alignment.center,
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 46),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VideoProgressIndicator(
                  c,
                  allowScrubbing: true,
                  padding: const EdgeInsets.all(6),
                  colors: VideoProgressColors(
                    playedColor: Theme.of(context).colorScheme.primary,
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.white10,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _start,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: AspectRatio(
          aspectRatio: _aspect,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.thumbPath != null)
                LocalImage(
                    path: widget.thumbPath!, radius: 0, fit: BoxFit.cover)
              else
                Container(color: palette.warm),
              Container(
                color: Colors.black26,
                alignment: Alignment.center,
                child: _initializing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Icon(
                        _failed
                            ? Icons.error_outline
                            : Icons.play_circle_fill,
                        color: Colors.white,
                        size: 46,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
