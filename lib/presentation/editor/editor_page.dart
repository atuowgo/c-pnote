import 'dart:async';

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
import '../widgets/local_image.dart';

/// 编辑中的媒体项（内存态，保存时写入 DB）。
class _PendingMedia {
  _PendingMedia({
    required this.id,
    required this.type,
    required this.localPath,
    this.thumbPath,
    this.sizeBytes,
  });

  final String id;
  final String type;
  final String localPath;
  final String? thumbPath;
  final int? sizeBytes;
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
        onMood: () {
          Navigator.pop(ctx);
          _openMoodSheet();
        },
        onSoon: (label) {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$label（后续里程碑）')));
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
                            LocalImage(
                                path: m.thumbPath ?? m.localPath,
                                width: 100,
                                height: 100),
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
    required this.onMood,
    required this.onSoon,
  });

  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onMood;
  final void Function(String label) onSoon;

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, VoidCallback)>[
      (Icons.photo_camera_outlined, '相机', onCamera),
      (Icons.photo_library_outlined, '图库', onGallery),
      (Icons.videocam_outlined, '视频', () => onSoon('视频')),
      (Icons.mic_none, '录音', () => onSoon('录音')),
      (Icons.sentiment_satisfied_outlined, '心情', onMood),
      (Icons.brush_outlined, '画板', () => onSoon('画板')),
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
