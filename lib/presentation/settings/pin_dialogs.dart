import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_lock.dart';

/// 弹窗设置新 PIN（两次输入确认一致）。取消返回 null。
Future<String?> promptCreatePin(BuildContext context) {
  final ctrl1 = TextEditingController();
  final ctrl2 = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      String? error;
      return StatefulBuilder(
        builder: (ctx, setState) {
          void submit() {
            final a = ctrl1.text.trim();
            final b = ctrl2.text.trim();
            if (a.length < 4 || !RegExp(r'^\d+$').hasMatch(a)) {
              setState(() => error = '请输入 4-6 位数字');
              return;
            }
            if (a != b) {
              setState(() => error = '两次输入的 PIN 不一致');
              return;
            }
            Navigator.pop(ctx, a);
          }

          return AlertDialog(
            title: const Text('设置 App 锁 PIN'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: ctrl1,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: '输入 4-6 位数字 PIN'),
                ),
                TextField(
                  controller: ctrl2,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(labelText: '再次输入确认'),
                  onSubmitted: (_) => submit(),
                ),
                if (error != null) ...[
                  const SizedBox(height: 4),
                  Text(error!, style: const TextStyle(color: Colors.red, fontSize: 12.5)),
                ],
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
              TextButton(onPressed: submit, child: const Text('确定')),
            ],
          );
        },
      );
    },
  );
}

/// 弹窗校验已有 PIN，成功返回 true，取消/失败关闭返回 false。
Future<bool> promptVerifyPin(BuildContext context, WidgetRef ref) async {
  final ctrl = TextEditingController();
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      String? error;
      return StatefulBuilder(
        builder: (ctx, setState) {
          Future<void> submit() async {
            final ok = await ref
                .read(appLockSettingsProvider.notifier)
                .verifyPin(ctrl.text.trim());
            if (ok) {
              if (ctx.mounted) Navigator.pop(ctx, true);
            } else {
              setState(() => error = 'PIN 不正确');
            }
          }

          return AlertDialog(
            title: const Text('验证 PIN'),
            content: TextField(
              controller: ctrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              autofocus: true,
              decoration: InputDecoration(labelText: '输入当前 PIN', errorText: error),
              onSubmitted: (_) => submit(),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('取消')),
              TextButton(onPressed: submit, child: const Text('确定')),
            ],
          );
        },
      );
    },
  );
  return result ?? false;
}
