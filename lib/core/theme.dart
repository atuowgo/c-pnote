import 'package:flutter/material.dart';

/// 额外的设计令牌（暖色底、发丝线、收藏色），随主题切换。
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.warm,
    required this.hairline,
    required this.subtle,
    required this.favorite,
  });

  final Color warm; // 顶部/头部暖色底
  final Color hairline; // 分隔线
  final Color subtle; // 次要文字
  final Color favorite; // 收藏/书签色

  @override
  AppPalette copyWith({
    Color? warm,
    Color? hairline,
    Color? subtle,
    Color? favorite,
  }) {
    return AppPalette(
      warm: warm ?? this.warm,
      hairline: hairline ?? this.hairline,
      subtle: subtle ?? this.subtle,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      warm: Color.lerp(warm, other.warm, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
      favorite: Color.lerp(favorite, other.favorite, t)!,
    );
  }
}

class AppTheme {
  static ThemeData light() {
    const accent = Color(0xFF3A6C86);
    const bg = Color(0xFFF4F0E8);
    const card = Color(0xFFFFFFFF);
    const ink = Color(0xFF33302B);

    final scheme = const ColorScheme.light(
      primary: accent,
      secondary: accent,
      surface: card,
      onSurface: ink,
      surfaceContainerHighest: Color(0xFFEFEAE0),
    );

    return _base(scheme, bg).copyWith(
      extensions: const [
        AppPalette(
          warm: Color(0xFFF7F2E9),
          hairline: Color(0xFFEBE4D6),
          subtle: Color(0xFF8B8073),
          favorite: Color(0xFFC6893F),
        ),
      ],
    );
  }

  static ThemeData dark() {
    const accent = Color(0xFF7FB6D4);
    const bg = Color(0xFF17161C);
    const card = Color(0xFF22212A);
    const ink = Color(0xFFE9E6EF);

    final scheme = const ColorScheme.dark(
      primary: accent,
      secondary: accent,
      surface: card,
      onSurface: ink,
      surfaceContainerHighest: Color(0xFF2A2933),
    );

    return _base(scheme, bg).copyWith(
      extensions: const [
        AppPalette(
          warm: Color(0xFF201F27),
          hairline: Color(0xFF2C2B35),
          subtle: Color(0xFF948FA0),
          favorite: Color(0xFFD6A960),
        ),
      ],
    );
  }

  static ThemeData _base(ColorScheme scheme, Color bg) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      fontFamily: null, // 使用系统 CJK 字体栈
    );
    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.primary,
        elevation: 4,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
