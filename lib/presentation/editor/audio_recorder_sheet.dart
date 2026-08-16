import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

import '../../core/theme.dart';

/// 录音完成结果：本地文件路径 + 时长。
class AudioRecordResult {
  const AudioRecordResult(this.path, this.durationMs);
  final String path;
  final int durationMs;
}

/// 打开录音底部弹层。[allocatePath] 用于在私有媒体目录内分配一个新文件路径。
/// 用户点“取消”返回 null；点“保存”返回 [AudioRecordResult]。
Future<AudioRecordResult?> showAudioRecorderSheet(
  BuildContext context, {
  required Future<String> Function() allocatePath,
}) {
  return showModalBottomSheet<AudioRecordResult>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => _AudioRecorderSheet(allocatePath: allocatePath),
  );
}

class _AudioRecorderSheet extends StatefulWidget {
  const _AudioRecorderSheet({required this.allocatePath});
  final Future<String> Function() allocatePath;

  @override
  State<_AudioRecorderSheet> createState() => _AudioRecorderSheetState();
}

class _AudioRecorderSheetState extends State<_AudioRecorderSheet> {
  final _recorder = AudioRecorder();
  Timer? _timer;
  StreamSubscription<Amplitude>? _ampSub;
  Duration _elapsed = Duration.zero;
  double _level = 0; // 0..1
  String? _path;
  String? _error;
  bool _preparing = true;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final granted = await _recorder.hasPermission();
      if (!granted) {
        setState(() {
          _error = '未获得录音权限，请在系统设置中开启';
          _preparing = false;
        });
        return;
      }
      _path = await widget.allocatePath();
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: _path!,
      );
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
      });
      _ampSub = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 200))
          .listen((amp) {
        if (!mounted) return;
        // dBFS 大致落在 -45..0，归一化成 0..1 的简单电平条。
        final normalized = ((amp.current + 45) / 45).clamp(0.0, 1.0);
        setState(() => _level = normalized);
      });
      setState(() => _preparing = false);
    } catch (e) {
      setState(() {
        _error = '无法开始录音：$e';
        _preparing = false;
      });
    }
  }

  Future<void> _finish({required bool save}) async {
    if (_finishing) return;
    setState(() => _finishing = true);
    _timer?.cancel();
    await _ampSub?.cancel();
    String? outPath;
    try {
      outPath = await _recorder.stop();
    } catch (_) {
      outPath = null;
    }
    await _recorder.dispose();

    if (!save || outPath == null) {
      if (outPath != null) {
        try {
          await File(outPath).delete();
        } catch (_) {}
      }
      if (mounted) Navigator.of(context).pop();
      return;
    }

    var durationMs = _elapsed.inMilliseconds;
    try {
      final probe = AudioPlayer();
      final d = await probe.setFilePath(outPath);
      if (d != null && d.inMilliseconds > 0) durationMs = d.inMilliseconds;
      await probe.dispose();
    } catch (_) {
      // 拿不到精确时长就用计时器估算值
    }

    if (mounted) {
      Navigator.of(context).pop(AudioRecordResult(outPath, durationMs));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampSub?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final primary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            if (_error != null) ...[
              Icon(Icons.mic_off, size: 40, color: palette.subtle),
              const SizedBox(height: 12),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: palette.subtle)),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('关闭'),
              ),
            ] else ...[
              Text(_preparing ? '准备录音…' : '正在录音',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 18),
              // 简单电平条
              SizedBox(
                height: 46,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(24, (i) {
                    final threshold = i / 24;
                    final active = !_preparing && _level > threshold;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      width: 4,
                      height: 8 + (active ? (threshold * 34) : 4),
                      decoration: BoxDecoration(
                        color: active
                            ? primary
                            : palette.hairline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Text(_fmt(_elapsed),
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontFeatures: [FontFeature.tabularFigures()])),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RoundButton(
                    icon: Icons.close,
                    label: '取消',
                    onTap: _preparing ? null : () => _finish(save: false),
                    background: palette.hairline,
                    foreground: palette.subtle,
                  ),
                  _RoundButton(
                    icon: Icons.check,
                    label: '保存',
                    onTap: (_preparing || _elapsed.inMilliseconds < 500)
                        ? null
                        : () => _finish(save: true),
                    background: primary,
                    foreground: Colors.white,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: CircleAvatar(
            radius: 28,
            backgroundColor:
                onTap == null ? background.withValues(alpha: 0.5) : background,
            child: Icon(icon, color: foreground),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12.5)),
      ],
    );
  }
}
