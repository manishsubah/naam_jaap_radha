import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/utils/date_keys.dart';
import 'package:naam_jaap/core/widgets/devotional_background.dart';
import 'package:naam_jaap/core/widgets/section_card.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/features/jaap/presentation/widgets/manual_entry_sheet.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _focused = DateTime.now();
  DateTime _selected = dayOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totals = ref.watch(dailyTotalsProvider);
    final goal = ref.watch(settingsProvider.select((s) => s.dailyGoal));
    final entries = ref.watch(jaapEntriesProvider);
    final selectedKey = dateKey(_selected);
    final dayEntries = entries.where((e) => e.dateKey == selectedKey).toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    final numbers = NumberFormat.decimalPattern('en_IN');

    return DevotionalBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Center(child: Text('Sadhana History', style: theme.appBarTheme.titleTextStyle)),
            const SizedBox(height: 16),
            SectionCard(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: TableCalendar<void>(
                firstDay: DateTime(2020),
                lastDay: DateTime.now(),
                focusedDay: _focused,
                startingDayOfWeek: StartingDayOfWeek.monday,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: theme.textTheme.titleMedium!,
                ),
                selectedDayPredicate: (day) => isSameDay(day, _selected),
                onDaySelected: (selected, focused) => setState(() {
                  _selected = dayOnly(selected);
                  _focused = focused;
                }),
                onPageChanged: (focused) => _focused = focused,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, _) => _DayCell(day: day, total: totals[dateKey(day)] ?? 0, goal: goal),
                  todayBuilder: (context, day, _) =>
                      _DayCell(day: day, total: totals[dateKey(day)] ?? 0, goal: goal, isToday: true),
                  selectedBuilder: (context, day, _) =>
                      _DayCell(day: day, total: totals[dateKey(day)] ?? 0, goal: goal, isSelected: true),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: DateFormat('d MMMM yyyy').format(_selected),
              trailing: IconButton(
                tooltip: 'Add count for this day',
                icon: const Icon(Icons.add_circle_outline_rounded),
                onPressed: () => showManualEntrySheet(context, date: _selected),
              ),
              child: dayEntries.isEmpty
                  ? Text('No jaap recorded on this day.', style: theme.textTheme.bodyMedium)
                  : Column(
                      children: [
                        for (final e in dayEntries) _EntryTile(entry: e),
                        const Divider(),
                        Row(
                          children: [
                            Text('Total', style: theme.textTheme.titleSmall),
                            const Spacer(),
                            Text(
                              numbers.format(totals[selectedKey] ?? 0),
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            SectionCard(title: 'Last 7 days', child: _WeekChart(totals: totals)),
            const SizedBox(height: 16),
            const SectionCard(title: 'Naam totals', child: _NaamTotals()),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.total,
    required this.goal,
    this.isToday = false,
    this.isSelected = false,
  });

  final DateTime day;
  final int total;
  final int goal;
  final bool isToday;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final intensity = total == 0 ? 0.0 : (total / math.max(goal, 1)).clamp(0.25, 1.0);
    final fill = total == 0
        ? Colors.transparent
        : Color.lerp(AppColors.lightGold, AppColors.kesari, intensity)!;

    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: theme.colorScheme.tertiary, width: 2.5)
            : isToday
                ? Border.all(color: AppColors.gold, width: 1.5)
                : null,
      ),
      child: Text(
        '${day.day}',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: intensity > 0.6 ? Colors.white : null,
          fontWeight: isToday || isSelected ? FontWeight.w700 : null,
        ),
      ),
    );
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({required this.entry});

  final JaapEntry entry;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: '${entry.count}');
    final value = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit count'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, int.tryParse(controller.text) ?? 0),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null) {
      await ref.read(jaapEntriesProvider.notifier).setCount(entry.dateKey, entry.naamId, value);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final naam = ref.watch(naamByIdProvider(entry.naamId));
    final malaSize = ref.watch(settingsProvider.select((s) => s.malaSize));
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.gold.withValues(alpha: 0.2),
        child: Text(
          (naam?.script ?? '?').characters.first,
          style: const TextStyle(color: AppColors.maroon, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(naam?.name ?? 'Removed naam'),
      subtitle: Text('${entry.count} jaap  •  ${entry.count ~/ malaSize} malas'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _edit(context, ref),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () =>
                ref.read(jaapEntriesProvider.notifier).setCount(entry.dateKey, entry.naamId, 0),
          ),
        ],
      ),
    );
  }
}

class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.totals});

  final Map<String, int> totals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = dayOnly(DateTime.now());
    final days = [for (var i = 6; i >= 0; i--) DateTime(today.year, today.month, today.day - i)];
    final values = [for (final d in days) totals[dateKey(d)] ?? 0];
    final maxY = math.max(values.reduce(math.max).toDouble(), 10.0) * 1.2;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.maroon,
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                '${rod.toY.toInt()}',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    DateFormat('E').format(days[value.toInt()]),
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < days.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: values[i].toDouble(),
                    width: 18,
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.kesari, AppColors.marigold],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _NaamTotals extends ConsumerWidget {
  const _NaamTotals();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totals = ref.watch(naamTotalsProvider);
    final naams = ref.watch(naamsProvider);
    final numbers = NumberFormat.decimalPattern('en_IN');
    final rows = totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    if (rows.isEmpty) {
      return Text('Your naam totals will appear here.', style: theme.textTheme.bodyMedium);
    }
    final max = rows.first.value;

    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      naams.where((n) => n.id == row.key).firstOrNull?.name ?? 'Removed naam',
                      style: theme.textTheme.titleSmall,
                    ),
                    const Spacer(),
                    Text(numbers.format(row.value), style: theme.textTheme.titleSmall),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: row.value / max,
                    minHeight: 8,
                    backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation(AppColors.saffron),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
