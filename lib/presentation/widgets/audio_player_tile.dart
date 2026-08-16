import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/theme.dart';

/// 音频播放条：播放/暂停按钮 + 进度条 + 时间。用于详情页与首页卡片。
class AudioPlayerTile extends StatefulWidget {
  const AudioPlayerTile({
    super.key,
    required this.path,
    this.durationMs,
    this.compact = false,
  });

  final String path;
  final int? durationMs;
  final bool compact;

  @override
  State<AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<AudioPlayerTile> {
  final _player = AudioPlayer();
  bool _loaded = false;
  bool _loadFailed = false;
  bool _loading = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_loadFailed) return;
    if (!_loaded) {
      setState(() => _loading = true);
      try {
        await _player.setFilePath(widget.path);
        _loaded = true;
      } catch (_) {
        if (mounted) {
          setState(() {
            _loadFailed = true;
            _loading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('音频播放失败')));
        }
        return;
      }
      if (mounted) setState(() => _loading = false);
    }
    if (_player.playing) {
      await _player.pause();
    } else {
      if (_player.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
      }
      await _player.play();
    }
  }

  String _fmt(Duration d) {
    if (d.isNegative) return '00:00';
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final primary = Theme.of(context).colorScheme.primary;
    final fallback = widget.durationMs != null
        ? Duration(milliseconds: widget.durationMs!)
        : Duration.zero;
    final compact = widget.compact;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 14, vertical: compact ? 6 : 10),
      decoration: BoxDecoration(
        color: palette.warm,
        borderRadius: BorderRadius.circular(compact ? 20 : 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _toggle,
            customBorder: const CircleBorder(),
            child: CircleAvatar(
              radius: compact ? 13 : 17,
              backgroundColor: primary,
              child: _loading
                  ? SizedBox(
                      width: compact ? 12 : 16,
                      height: compact ? 12 : 16,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, snap) {
                        final playing = snap.data?.playing ?? false;
                        return Icon(
                          _loadFailed
                              ? Icons.error_outline
                              : (playing ? Icons.pause : Icons.play_arrow),
                          size: compact ? 15 : 19,
                          color: Colors.white,
                        );
                      },
                    ),
            ),
          ),
          SizedBox(width: compact ? 8 : 12),
          SizedBox(
            width: compact ? 84 : 160,
            child: StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, snap) {
                final pos = snap.data ?? Duration.zero;
                final dur = (_loaded ? _player.duration : null) ?? fallback;
                final ratio = dur.inMilliseconds > 0
                    ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
                    : 0.0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: compact ? 3 : 4,
                        backgroundColor: palette.hairline,
                        valueColor: AlwaysStoppedAnimation(primary),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text('${_fmt(pos)} / ${_fmt(dur)}',
                        style: TextStyle(
                            fontSize: compact ? 10.5 : 11.5,
                            color: palette.subtle)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
