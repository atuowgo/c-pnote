import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_lock.dart';
import 'lock_screen.dart';

/// 包裹整个应用：开启 App 锁后，冷启动 / 从后台恢复都会要求重新验证。
/// 仅在真正被完全切到后台（paused/hidden）时清除“已解锁”状态，避免
/// 生物识别系统弹窗触发的 inactive 状态被误判为需要重新加锁。
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lock = ref.read(appLockSettingsProvider);
    if (!lock.enabled || !lock.hasPin) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      ref.read(appUnlockedProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(appLockSettingsProvider);
    final unlocked = ref.watch(appUnlockedProvider);
    final locked = lock.enabled && lock.hasPin && !unlocked;

    return Stack(
      children: [
        widget.child,
        if (locked) const LockScreen(),
      ],
    );
  }
}
