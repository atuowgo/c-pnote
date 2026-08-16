import 'dart:async';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/db/app_database.dart';
import '../../data/device_service.dart';
import '../../providers.dart';
import '../sketch/sketch_page.dart';
import '../widgets/local_image.dart';
import 'audio_recorder_sheet.dart';

/// 编辑中的媒体项（内存态，保存时写入 DB）。
class _PendingMedia {
  _PendingMedia({
    required this.id,
    required this.type,
    required this.localPath,
    this.thumbPath,
    this.sizeBytes,
    this.durationMs,
    this.width,
    this.height,
  });

  final String id;
  final String type;
  final String localPath;
  final String? thumbPath;
  final int? sizeBytes;
  final int? durationMs;
  final int? width;
  final int? height;
}

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({super.key, this.entryId});

  /// 传入已有 id 则为编辑，否则新建。
  final String? entryId;

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage> {
  static const _uuid = Uuid();
  static const _weatherOptions = ['晴', '多云', '阴', '小雨', '雪'];

  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _picker = ImagePicker();

  late final String _id;
  final List<_PendingMedia> _media = [];

  DateTime _entryDate = DateTime.now();
  DateTime? _createdAt;
  String? _mood;
  String? _weather;
  String? _location;
  String? _device;

  Timer? _debounce;
  bool _persisted = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _id = widget.entryId ?? _uuid.v4();
    _titleCtrl.addListener(_scheduleSave);
    _bodyCtrl.addListener(_scheduleSave);
    if (widget.entryId != null) {
      _loadExisting();
    } else {
      _initNew();
    }
  }

  Future<void> _initNew() async {
    final model = await currentDeviceModel();
    if (mounted) setState(() => _device = model);
  }

  Future<void> _loadExisting() async {
    setState(() => _loading = true);
    final entry = await ref.read(diaryRepositoryProvider).getEntry(_id);
    if (entry == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    _titleCtrl.text = entry.diary.title ?? '';
    _bodyCtrl.text = entry.diary.body;
    _entryDate = entry.diary.entryDate;
    _createdAt = entry.diary.createdAt;
    _mood = entry.diary.mood;
    _weather = entry.diary.weather;
    _location = entry.diary.locationName;
    _device = entry.diary.device;
    _media.addAll(entry.media.map((m) => _PendingMedia(
          id: m.id,
          type: m.type,
          localPath: m.localPath,
          thumbPath: m.thumbPath,
          sizeBytes: m.sizeBytes,
          durationMs: m.durationMs,
          width: m.width,
          height: m.height,
        )));
    _persisted = true;
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _finalize();
    super.dispose();
  }

  bool get _hasContent =>
      _bodyCtrl.text.trim().isNotEmpty ||
      _titleCtrl.text.trim().isNotEmpty ||
      _media.isNotEmpty ||
      _mood != null;

  int get _wordCount =>
      _bodyCtrl.text.replaceAll(RegExp(r'\s'), '').characters.length;

  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), _save);
  }

  Future<void> _save() async {
    final repo = ref.read(diaryRepositoryProvider);
    if (!_hasContent) {
      if (_persisted) {
        await repo.delete(_id);
        _persisted = false;
      }
      return;
    }
    final now = DateTime.now();
    _createdAt ??= now;
    final companion = DiariesCompanion(
      id: Value(_id),
      entryDate: Value(
          DateTime(_entryDate.year, _entryDate.month, _entryDate.day)),
      createdAt: Value(_createdAt!),
      updatedAt: Value(now),
      title: Value(_titleCtrl.text.trim().isEmpty ? null : _titleCtrl.text.trim()),
      body: Value(_bodyCtrl.text),
      mood: Value(_mood),
      weather: Value(_weather),
      locationName: Value(_location),
      device: Value(_device),
      wordCount: Value(_wordCount),
    );
    final media = [
      for (var i = 0; i < _media.length; i++)
        MediaAssetsCompanion(
          id: Value(_media[i].id),
          diaryId: Value(_id),
          type: Value(_media[i].type),
          localPath: Value(_media[i].localPath),
          thumbPath: Value(_media[i].thumbPath),
          sizeBytes: Value(_media[i].sizeBytes),
          durationMs: Value(_media[i].durationMs),
          width: Value(_media[i].width),
          height: Value(_media[i].height),
          orderIndex: Value(i),
        ),
    ];
    await repo.saveEntry(diary: companion, media: media);
    _persisted = true;
  }

  void _finalize() {
    // 立即执行一次最终保存（不等 debounce）
    unawaited(_save());
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 100);
      if (picked == null) return;
      final saved =
          await ref.read(mediaStorageProvider).saveImage(picked.path);
      if (saved == null) return;
      setState(() {
        _media.add(_PendingMedia(
          id: saved.id,
          type: 'image',
          localPath: saved.path,
          thumbPath: saved.thumbPath,
          sizeBytes: saved.sizeBytes,
        ));
      });
      _scheduleSave();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('插入图片失败：$e')));
      }
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    try {
      final picked = await _picker.pickVideo(
          source: source, maxDuration: const Duration(minutes: 10));
      if (picked == null) return;
      final saved =
          await ref.read(mediaStorageProvider).saveVideo(picked.path);
      if (saved == null) return;
      if (!mounted) return;
      setState(() {
        _media.add(_PendingMedia(
          id: saved.id,
          type: 'video',
          localPath: saved.path,
          thumbPath: saved.thumbPath,
          sizeBytes: saved.sizeBytes,
          durationMs: saved.durationMs,
          width: saved.width,
          height: saved.height,
        ));
      });
      _scheduleSave();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('插入视频失败：$e')));
      }
    }
  }

  void _openVideoSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('拍摄视频'),
              onTap: () {
                Navigator.pop(ctx);
                _pickVideo(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(ctx);
                _pickVideo(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _recordAudio() async {
    final storage = ref.read(mediaStorageProvider);
    final result = await showAudioRecorderSheet(
      context,
      allocatePath: () => storage.allocatePath('m4a'),
    );
    if (result == null) return;
    final size = await storage.fileSize(result.path);
    if (!mounted) return;
    setState(() {
      _media.add(_PendingMedia(
        id: _uuid.v4(),
        type: 'audio',
        localPath: result.path,
        sizeBytes: size,
        durationMs: result.durationMs,
      ));
    });
    _scheduleSave();
  }

  Future<void> _openSketch() async {
    final bytes = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(builder: (_) => const SketchPage()),
    );
    if (bytes == null) return;
    final storage = ref.read(mediaStorageProvider);
    final path = await storage.saveBytes(bytes, 'png');
    final size = await storage.fileSize(path);
    if (!mounted) return;
    setState(() {
      _media.add(_PendingMedia(
        id: _uuid.v4(),
        type: 'sketch',
        localPath: path,
        sizeBytes: size,
      ));
    });
    _scheduleSave();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _entryDate = picked);
      _scheduleSave();
    }
  }

  void _openInsertSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => _InsertSheet(
        onCamera: () {
          Navigator.pop(ctx);
          _pickImage(ImageSource.camera);
        },
        onGallery: () {
          Navigator.pop(ctx);
          _pickImage(ImageSource.gallery);
        },
        onVideo: () {
          Navigator.pop(ctx);
          _openVideoSourceSheet();
        },
        onAudio: () {
          Navigator.pop(ctx);
          _recordAudio();
        },
        onMood: () {
          Navigator.pop(ctx);
          _openMoodSheet();
        },
        onSketch: () {
          Navigator.pop(ctx);
          _openSketch();
        },
      ),
    );
  }

  void _openMoodSheet() {
    const moods = ['😄', '🙂', '😐', '😮‍💨', '😔', '😣'];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('今天心情如何？', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final m in moods)
                  GestureDetector(
                    onTap: () {
                      setState(() => _mood = m);
                      _scheduleSave();
                      Navigator.pop(ctx);
                    },
                    child: Text(m, style: const TextStyle(fontSize: 30)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editLocation() async {
    final ctrl = TextEditingController(text: _location ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('位置'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: '输入地点（M2 将支持自动定位）'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('确定')),
        ],
      ),
    );
    if (result != null) {
      setState(() => _location = result.trim().isEmpty ? null : result.trim());
      _scheduleSave();
    }
  }

  void _pickWeather() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            for (final w in _weatherOptions)
              ListTile(
                title: Text(w),
                onTap: () {
                  setState(() => _weather = w);
                  _scheduleSave();
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: InkWell(
          onTap: _pickDate,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Fmt.monthDay(_entryDate),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                '${Fmt.hm(_createdAt ?? DateTime.now())} ${Fmt.weekday(_entryDate)}',
                style: TextStyle(fontSize: 12, color: palette.subtle),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
              children: [
                TextField(
                  controller: _titleCtrl,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '标题（可选）',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bodyCtrl,
                  maxLines: null,
                  minLines: 5,
                  style: const TextStyle(fontSize: 16, height: 1.7),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '记录今日',
                  ),
                ),
                if (_media.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in _media)
                        Stack(
                          children: [
                            _mediaPreview(m),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _media.remove(m));
                                  _scheduleSave();
                                },
                                child: const CircleAvatar(
                                  radius: 11,
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.close,
                                      size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 26),
                _metaRows(palette),
              ],
            ),
          ),
          _toolbar(palette),
        ],
      ),
    );
  }

  Widget _mediaPreview(_PendingMedia m) {
    switch (m.type) {
      case 'image':
      case 'sketch':
        return LocalImage(path: m.thumbPath ?? m.localPath, width: 100, height: 100);
      case 'video':
        return Container(
          width: 100,
          height: 100,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              m.thumbPath != null
                  ? LocalImage(path: m.thumbPath!, radius: 0, fit: BoxFit.cover)
                  : Container(color: Theme.of(context).extension<AppPalette>()!.warm),
              const ColoredBox(color: Colors.black26),
              const Icon(Icons.play_circle_fill, color: Colors.white, size: 28),
            ],
          ),
        );
      case 'audio':
        final secs = ((m.durationMs ?? 0) / 1000).round();
        return Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).extension<AppPalette>()!.warm,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.graphic_eq,
                  color: Theme.of(context).colorScheme.primary, size: 26),
              const SizedBox(height: 6),
              Text('$secs″', style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      default:
        return Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).extension<AppPalette>()!.warm,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.insert_drive_file_outlined),
        );
    }
  }

  Widget _metaRows(AppPalette palette) {
    final style = TextStyle(fontSize: 14, color: palette.subtle);
    Widget row(IconData icon, String text, VoidCallback? onTap,
        {Color? color}) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Icon(icon, size: 17, color: color ?? palette.subtle),
              const SizedBox(width: 11),
              Text(text, style: color != null ? style.copyWith(color: color) : style),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row(Icons.wb_cloudy_outlined, _weather ?? '选择天气', _pickWeather),
        row(Icons.place_outlined, _location ?? '添加位置', _editLocation),
        if ((_device ?? '').isNotEmpty)
          row(Icons.smartphone_outlined, _device!, null),
        row(Icons.translate, '字数统计 · $_wordCount', null),
        row(
          Icons.sentiment_satisfied_outlined,
          _mood == null ? '添加心情' : '心情 $_mood',
          _openMoodSheet,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _toolbar(AppPalette palette) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: palette.hairline)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: _openInsertSheet,
                icon: Icon(Icons.add, color: primary),
                tooltip: '插入'),
            IconButton(
                onPressed: () => _soon('标签'),
                icon: const Icon(Icons.tag)),
            IconButton(
                onPressed: () => _soon('撤销'),
                icon: const Icon(Icons.undo)),
            IconButton(
                onPressed: () => _soon('列表'),
                icon: const Icon(Icons.format_list_bulleted)),
            IconButton(
                onPressed: () => _soon('AI 辅助'),
                icon: Icon(Icons.auto_awesome_outlined, color: primary)),
            IconButton(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined)),
          ],
        ),
      ),
    );
  }

  void _soon(String label) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$label（后续里程碑）')));
  }
}

class _InsertSheet extends StatelessWidget {
  const _InsertSheet({
    required this.onCamera,
    required this.onGallery,
    required this.onVideo,
    required this.onAudio,
    required this.onMood,
    required this.onSketch,
  });

  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onVideo;
  final VoidCallback onAudio;
  final VoidCallback onMood;
  final VoidCallback onSketch;

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, VoidCallback)>[
      (Icons.photo_camera_outlined, '相机', onCamera),
      (Icons.photo_library_outlined, '图库', onGallery),
      (Icons.videocam_outlined, '视频', onVideo),
      (Icons.mic_none, '录音', onAudio),
      (Icons.sentiment_satisfied_outlined, '心情', onMood),
      (Icons.brush_outlined, '画板', onSketch),
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 20),
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
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              children: [
                for (final it in items)
                  InkWell(
                    onTap: it.$3,
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(it.$1, size: 28),
                        const SizedBox(height: 9),
                        Text(it.$2, style: const TextStyle(fontSize: 13.5)),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
