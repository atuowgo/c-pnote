import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../core/theme.dart';

class _Stroke {
  _Stroke(this.color, this.width) : points = [];
  final Color color;
  final double width;
  final List<Offset> points;
}

/// 简易手绘画板：颜色/粗细、橡皮、撤销、清空，保存为 PNG 字节返回给调用方。
class SketchPage extends StatefulWidget {
  const SketchPage({super.key});

  @override
  State<SketchPage> createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  final _boundaryKey = GlobalKey();
  final List<_Stroke> _strokes = [];
  final List<_Stroke> _redoStack = [];

  static const _palette = <Color>[
    Colors.black,
    Color(0xFFD9534F),
    Color(0xFFE8A33D),
    Color(0xFF4C9F70),
    Color(0xFF3A6C86),
    Color(0xFF8B5FBF),
  ];

  Color _color = _palette.first;
  double _width = 4;
  bool _erasing = false;
  bool _saving = false;

  void _onPanStart(DragStartDetails d) {
    setState(() {
      _redoStack.clear();
      _strokes.add(
        _Stroke(_erasing ? Colors.white : _color, _erasing ? _width * 3.2 : _width)
          ..points.add(d.localPosition),
      );
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.last.points.add(d.localPosition));
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() => _redoStack.add(_strokes.removeLast()));
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() => _strokes.add(_redoStack.removeLast()));
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _redoStack.clear();
    });
  }

  Future<void> _save() async {
    if (_strokes.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _saving = true);
    try {
      final boundary = _boundaryKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw StateError('encode failed');
      if (mounted) {
        Navigator.of(context).pop(byteData.buffer.asUint8List());
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('保存画板失败：$e')));
      }
    }
  }

  Future<void> _confirmDiscard() async {
    if (_strokes.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('放弃画板？'),
        content: const Text('尚未保存的涂鸦将会丢失。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('继续画')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('放弃')),
        ],
      ),
    );
    if (ok == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _confirmDiscard,
        ),
        title: const Text('画板'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _strokes.isEmpty ? null : _undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _redoStack.isEmpty ? null : _redo,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: (_strokes.isEmpty && _redoStack.isEmpty) ? null : _clear,
          ),
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? '保存中…' : '完成'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: _boundaryKey,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  child: CustomPaint(
                    painter: _SketchPainter(_strokes),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      for (final c in _palette)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() {
                                  _color = c;
                                  _erasing = false;
                                }),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: (!_erasing && c == _color)
                                      ? palette.subtle
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        tooltip: '橡皮擦',
                        icon: Icon(
                          Icons.auto_fix_normal_outlined,
                          color: _erasing
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        onPressed: () => setState(() => _erasing = !_erasing),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.line_weight, size: 18, color: palette.subtle),
                      Expanded(
                        child: Slider(
                          value: _width,
                          min: 1,
                          max: 20,
                          onChanged: (v) => setState(() => _width = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SketchPainter extends CustomPainter {
  _SketchPainter(this.strokes);
  final List<_Stroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in strokes) {
      final paint = Paint()
        ..color = s.color
        ..strokeWidth = s.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      if (s.points.length == 1) {
        canvas.drawCircle(
            s.points.first, s.width / 2, paint..style = PaintingStyle.fill);
        continue;
      }
      final path = Path()..moveTo(s.points.first.dx, s.points.first.dy);
      for (final pt in s.points.skip(1)) {
        path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SketchPainter oldDelegate) => true;
}
