import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_lock.dart';
import '../../core/theme.dart';

/// 全屏锁定页：优先尝试生物识别，失败/不可用则回退到 PIN 数字键盘。
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  String _input = '';
  String? _error;
  bool _autoAttempted = false;
  bool _bioBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_autoAttempted) {
        _autoAttempted = true;
        _tryBiometric();
      }
    });
  }

  Future<void> _tryBiometric() async {
    if (_bioBusy) return;
    final auth = ref.read(localAuthProvider);
    try {
      final supported = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;
      if (!supported && !canCheck) return;
      setState(() => _bioBusy = true);
      final ok = await auth.authenticate(
        localizedReason: '验证以解锁日记本',
        biometricOnly: false,
      );
      if (ok && mounted) {
        ref.read(appUnlockedProvider.notifier).state = true;
      }
    } catch (_) {
      // 生物识别不可用 / 被取消，静默回退到 PIN 输入
    } finally {
      if (mounted) setState(() => _bioBusy = false);
    }
  }

  void _onDigit(String d) {
    if (_input.length >= 6) return;
    setState(() {
      _input += d;
      _error = null;
    });
    if (_input.length == 4) _submit();
  }

  void _backspace() {
    if (_input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  Future<void> _submit() async {
    final pin = _input;
    final ok =
        await ref.read(appLockSettingsProvider.notifier).verifyPin(pin);
    if (!mounted) return;
    if (ok) {
      ref.read(appUnlockedProvider.notifier).state = true;
    } else {
      setState(() {
        _error = 'PIN 不正确';
        _input = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Icon(Icons.lock_outline, size: 44, color: palette.subtle),
            const SizedBox(height: 14),
            const Text('手机日记本已锁定',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('输入 PIN 或使用生物识别解锁',
                style: TextStyle(fontSize: 12.5, color: palette.subtle)),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < _input.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? primary : Colors.transparent,
                    border: Border.all(color: palette.subtle),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 22,
              child: _error == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_error!,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 12.5)),
                    ),
            ),
            const Spacer(flex: 1),
            _NumberPad(onDigit: _onDigit, onBackspace: _backspace),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _bioBusy ? null : _tryBiometric,
              icon: const Icon(Icons.fingerprint),
              label: const Text('使用生物识别'),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  const _NumberPad({required this.onDigit, required this.onBackspace});
  final void Function(String) onDigit;
  final VoidCallback onBackspace;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in _rows)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final key in row)
                SizedBox(
                  width: 78,
                  height: 58,
                  child: key.isEmpty
                      ? const SizedBox.shrink()
                      : TextButton(
                          onPressed: () =>
                              key == '⌫' ? onBackspace() : onDigit(key),
                          child: Text(key, style: const TextStyle(fontSize: 22)),
                        ),
                ),
            ],
          ),
      ],
    );
  }
}
