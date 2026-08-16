package com.cpnote.pnote

import io.flutter.embedding.android.FlutterFragmentActivity

// local_auth（App 锁 · 生物识别）要求宿主 Activity 是 FragmentActivity 的子类，
// 因此这里改用 FlutterFragmentActivity 替代默认的 FlutterActivity。
class MainActivity : FlutterFragmentActivity()
