import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_lock.dart';
import '../../core/settings.dart';
import '../../core/theme.dart';
import 'pin_dialogs.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final mode = ref.watch(themeModeProvider);
    final lock = ref.watch(appLockSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          _group(palette, '通用'),
          _card([
            ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text('主题'),
              trailing: Text(_modeLabel(mode),
                  style: TextStyle(color: palette.subtle)),
              onTap: () => _pickTheme(context, ref, mode),
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('字体与字号'),
              trailing: Text('标准', style: TextStyle(color: palette.subtle)),
              onTap: () => _soon(context),
            ),
          ]),
          _group(palette, '安全与隐私'),
          _card([
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('App 锁（PIN / 生物识别）'),
              subtitle: Text(lock.enabled ? '已开启' : '未开启',
                  style: TextStyle(color: palette.subtle)),
              trailing: Switch(
                value: lock.enabled,
                onChanged: (v) => _toggleLock(context, ref, v),
              ),
            ),
            if (lock.enabled)
              ListTile(
                leading: const SizedBox(width: 24),
                title: const Text('修改 PIN'),
                onTap: () => _changePin(context, ref),
              ),
          ]),
          _group(palette, '备份与同步'),
          _card([
            ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text('端到端加密云同步'),
              trailing: Text('未开启', style: TextStyle(color: palette.subtle)),
              onTap: () => _soon(context),
            ),
            ListTile(
              leading: const Icon(Icons.import_export),
              title: const Text('导入 / 导出（含 PDF 导入）'),
              onTap: () => _soon(context),
            ),
          ]),
          _group(palette, 'AI 助手'),
          _card([
            ListTile(
              leading: const Icon(Icons.auto_awesome_outlined),
              title: const Text('启用 AI 能力'),
              trailing: Switch(value: false, onChanged: (_) => _soon(context)),
            ),
          ]),
          const SizedBox(height: 24),
          Center(
            child: Text('手机日记本 · v1.0.0 (M1)',
                style: TextStyle(color: palette.subtle, fontSize: 12)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _group(AppPalette palette, String label) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: palette.subtle)),
      );

  Widget _card(List<Widget> children) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          child: Column(children: children),
        ),
      );

  String _modeLabel(ThemeMode m) => switch (m) {
        ThemeMode.light => '浅色',
        ThemeMode.dark => '深色',
        ThemeMode.system => '跟随系统',
      };

  void _pickTheme(BuildContext context, WidgetRef ref, ThemeMode current) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: RadioGroup<ThemeMode>(
          groupValue: current,
          onChanged: (v) {
            if (v != null) {
              ref.read(themeModeProvider.notifier).setThemeMode(v);
            }
            Navigator.pop(ctx);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final m in ThemeMode.values)
                RadioListTile<ThemeMode>(
                  value: m,
                  title: Text(_modeLabel(m)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('该功能将在后续里程碑上线')));
  }

  Future<void> _toggleLock(
      BuildContext context, WidgetRef ref, bool value) async {
    final controller = ref.read(appLockSettingsProvider.notifier);
    if (value) {
      final pin = await promptCreatePin(context);
      if (pin == null) return;
      await controller.setPin(pin);
      await controller.setEnabled(true);
      // 刚设置完毕，视为已通过验证，避免立刻又弹出锁屏。
      ref.read(appUnlockedProvider.notifier).state = true;
    } else {
      if (!context.mounted) return;
      final ok = await promptVerifyPin(context, ref);
      if (!ok) return;
      await controller.setEnabled(false);
    }
  }

  Future<void> _changePin(BuildContext context, WidgetRef ref) async {
    final verified = await promptVerifyPin(context, ref);
    if (!verified) return;
    if (!context.mounted) return;
    final pin = await promptCreatePin(context);
    if (pin == null) return;
    await ref.read(appLockSettingsProvider.notifier).setPin(pin);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PIN 已更新')));
    }
  }
}
