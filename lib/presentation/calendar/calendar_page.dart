import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme.dart';
import '../../domain/diary_entry.dart';
import '../../providers.dart';
import '../detail/detail_page.dart';

/// 日历视图：月历打点 + 点选某天查看当天日记。
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  static const _weekdayHeaders = ['日', '一', '二', '三', '四', '五', '六'];

  late DateTime _month;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  void _changeMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
      _selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final entriesAsync = ref.watch(entriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${_month.year} 年 ${_month.month} 月'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeMonth(-1),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeMonth(1),
          ),
        ],
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (entries) {
          final byDay = <DateTime, List<DiaryEntry>>{};
          for (final e in entries) {
            final k = DateTime(e.diary.entryDate.year, e.diary.entryDate.month,
                e.diary.entryDate.day);
            byDay.putIfAbsent(k, () => []).add(e);
          }
          final monthCount = byDay.keys
              .where((k) => k.year == _month.year && k.month == _month.month)
              .length;

          final daysInMonth =
              DateTime(_month.year, _month.month + 1, 0).day;
          final firstWeekday = DateTime(_month.year, _month.month, 1).weekday;
          final leadingBlanks = firstWeekday % 7; // 周日=7 -> 0 列开头

          final today = DateTime.now();
          final selected = _selectedDay;
          final selectedEntries =
              selected != null ? (byDay[selected] ?? const []) : const [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Row(
                  children: [
                    for (final w in _weekdayHeaders)
                      Expanded(
                        child: Center(
                          child: Text(w,
                              style: TextStyle(
                                  fontSize: 12, color: palette.subtle)),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                  ),
                  itemCount: leadingBlanks + daysInMonth,
                  itemBuilder: (context, i) {
                    if (i < leadingBlanks) return const SizedBox.shrink();
                    final day = i - leadingBlanks + 1;
                    final date = DateTime(_month.year, _month.month, day);
                    final hasEntry = byDay.containsKey(date);
                    final isToday = date.year == today.year &&
                        date.month == today.month &&
                        date.day == today.day;
                    final isSelected = selected != null &&
                        date.year == selected.year &&
                        date.month == selected.month &&
                        date.day == selected.day;
                    return Padding(
                      padding: const EdgeInsets.all(3),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: hasEntry
                            ? () => setState(() => _selectedDay = date)
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : (isToday ? palette.warm : null),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: hasEntry
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? Colors.white
                                      : (hasEntry
                                          ? null
                                          : palette.subtle.withValues(alpha: 0.7)),
                                ),
                              ),
                              const SizedBox(height: 2),
                              if (hasEntry)
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Colors.white
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                child: Row(
                  children: [
                    Text('${_month.month} 月共记录 $monthCount 天',
                        style: TextStyle(fontSize: 12, color: palette.subtle)),
                    const Spacer(),
                    if (selected != null)
                      Text(
                        '${Fmt.monthDay(selected)} · ${Fmt.weekday(selected)}',
                        style: const TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: selected == null
                    ? Center(
                        child: Text('点击有记录的日期查看',
                            style: TextStyle(color: palette.subtle)),
                      )
                    : selectedEntries.isEmpty
                        ? Center(
                            child: Text('这天还没有日记',
                                style: TextStyle(color: palette.subtle)),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                            itemCount: selectedEntries.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) =>
                                _DayEntryTile(entry: selectedEntries[i]),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DayEntryTile extends StatelessWidget {
  const _DayEntryTile({required this.entry});
  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;
    final d = entry.diary;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DetailPage(entryId: d.id)),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((d.title ?? '').isNotEmpty) ...[
                Text(d.title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14.5)),
                const SizedBox(height: 4),
              ],
              if (d.body.isNotEmpty)
                Text(
                  d.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13.5, height: 1.55),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 12, color: palette.subtle),
                  const SizedBox(width: 4),
                  Text(Fmt.hm(d.createdAt),
                      style: TextStyle(fontSize: 11.5, color: palette.subtle)),
                  if ((d.weather ?? '').isNotEmpty)
                    Text(' · ${d.weather}',
                        style: TextStyle(fontSize: 11.5, color: palette.subtle)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
