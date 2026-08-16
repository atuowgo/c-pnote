import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

/// App 锁设置：是否开启 + 是否已设置 PIN（PIN 本身只存哈希，从不明文落盘）。
class AppLockSettings {
  const AppLockSettings({required this.enabled, required this.hasPin});
  final bool enabled;
  final bool hasPin;

  AppLockSettings copyWith({bool? enabled, bool? hasPin}) => AppLockSettings(
        enabled: enabled ?? this.enabled,
        hasPin: hasPin ?? this.hasPin,
      );
}

class AppLockController extends StateNotifier<AppLockSettings> {
  AppLockController(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;
  static const _kEnabled = 'appLock.enabled';
  static const _kPinHash = 'appLock.pinHash';
  static const _kSalt = 'appLock.salt';

  static AppLockSettings _load(SharedPreferences prefs) {
    return AppLockSettings(
      enabled: prefs.getBool(_kEnabled) ?? false,
      hasPin: (prefs.getString(_kPinHash) ?? '').isNotEmpty,
    );
  }

  String _hash(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt:$pin')).toString();
  }

  /// 设置/更新 PIN：随机盐 + SHA-256 哈希后存储。
  Future<void> setPin(String pin) async {
    final salt = DateTime.now().microsecondsSinceEpoch.toString();
    await _prefs.setString(_kSalt, salt);
    await _prefs.setString(_kPinHash, _hash(pin, salt));
    state = state.copyWith(hasPin: true);
  }

  Future<bool> verifyPin(String pin) async {
    final salt = _prefs.getString(_kSalt) ?? '';
    final stored = _prefs.getString(_kPinHash) ?? '';
    if (stored.isEmpty || pin.isEmpty) return false;
    return _hash(pin, salt) == stored;
  }

  Future<void> setEnabled(bool value) async {
    await _prefs.setBool(_kEnabled, value);
    state = state.copyWith(enabled: value);
  }

  Future<void> clearPin() async {
    await _prefs.remove(_kPinHash);
    await _prefs.remove(_kSalt);
    state = state.copyWith(hasPin: false);
  }
}

final appLockSettingsProvider =
    StateNotifierProvider<AppLockController, AppLockSettings>((ref) {
  return AppLockController(ref.watch(sharedPreferencesProvider));
});

/// 本次会话是否已通过验证（不持久化）：冷启动 / 每次 provider 容器重建默认 false。
final appUnlockedProvider = StateProvider<bool>((ref) => false);

final localAuthProvider =
    Provider<LocalAuthentication>((ref) => LocalAuthentication());
