import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// 读取设备型号，用于日记元数据（截图中的「OPPO Find X9 Pro」）。
Future<String?> currentDeviceModel() async {
  try {
    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final a = await info.androidInfo;
      final brand = a.manufacturer.isNotEmpty ? a.manufacturer : a.brand;
      return '$brand ${a.model}'.trim();
    }
    if (Platform.isIOS) {
      final i = await info.iosInfo;
      return i.utsname.machine;
    }
  } catch (_) {
    // 读取失败时忽略，元数据可为空
  }
  return null;
}
