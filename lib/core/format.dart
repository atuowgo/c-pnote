/// 中文日期/时间格式化助手。
class Fmt {
  static const _weekdays = ['一', '二', '三', '四', '五', '六', '日'];

  /// 周几，如「周一」。DateTime.weekday: 1=Mon..7=Sun
  static String weekday(DateTime d) => '周${_weekdays[d.weekday - 1]}';

  /// 「8月16日」
  static String monthDay(DateTime d) => '${d.month}月${d.day}日';

  /// 「2026 / 08 / 16」
  static String ymdSlash(DateTime d) =>
      '${d.year} / ${_two(d.month)} / ${_two(d.day)}';

  /// 「11:39」
  static String hm(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';

  /// 相对年份描述，用于历史今天：如「1 年前」。
  static String yearsAgo(DateTime past, DateTime now) {
    final years = now.year - past.year;
    return years <= 0 ? '今年' : '$years 年前';
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}
