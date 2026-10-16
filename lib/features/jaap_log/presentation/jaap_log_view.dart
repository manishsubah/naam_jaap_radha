import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:naam_jaap/core/theme/app_colors.dart';
import 'package:naam_jaap/core/utils/date_keys.dart';
import 'package:naam_jaap/core/widgets/section_card.dart';
import 'package:naam_jaap/data/models/naam.dart';
import 'package:naam_jaap/data/providers/providers.dart';
import 'package:naam_jaap/data/sync/sync_controller.dart';
import 'package:naam_jaap/features/jaap_log/domain/ledger.dart';
import 'package:naam_jaap/features/jaap_log/presentation/widgets/jaap_record_sheet.dart';

final _numbers = NumberFormat.decimalPattern('en_IN');

/// Every jaap record grouped by day, newest first. Each row shows the jaap
/// name, the day's count, and that naam's running total up to that day.
class JaapLogView extends ConsumerStatefulWidget {
  const JaapLogView({super.key, this.header = const []});

  /// Widgets shown above the log, scrolling with it.
  final List<Widget> header;

  @override
  ConsumerState<JaapLogView> createState() => _JaapLogViewState();
}

class _JaapLogViewState extends ConsumerState<JaapLogView> {
  String? _naamFilter;

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(jaapEntriesProvider);
    final naams = ref.watch(naamsProvider);
    final usedNaamIds = {for (final e in entries) e.naamId};
    if (_naamFilter != null && !usedNaamIds.contains(_naamFilter)) _naamFilter = null;
    final days = buildLedger(entries, naamId: _naamFilter);

    final top = <Widget>[
      ...widget.header,
      Row(
        children: [
          const Expanded(child: _SyncBadge()),
          FilledButton.tonalIcon(
            onPressed: () => showJaapRecordSheet(context, naamId: _naamFilter),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add record'),
          ),
        ],
      ),
      if (usedNaamIds.length > 1) ...[
        const SizedBox(height: 12),
        _NaamFilter(
          naams: [for (final n in naams) if (usedNaamIds.contains(n.id)) n],
          selected: _naamFilter,
          onSelected: (id) => setState(() => _naamFilter = id),
        ),
      ],
      const SizedBox(height: 12),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: top.length + (days.isEmpty ? 1 : days.length),
      itemBuilder: (context, index) {
        if (index < top.length) return top[index];
        if (days.isEmpty) return const _EmptyLog();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _DayCard(day: days[index - top.length]),
        );
      },
    );
  }
}

class _NaamFilter extends StatelessWidget {
  const _NaamFilter({required this.naams, required this.selected, required this.onSelected});

  final List<Naam> naams;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final n in naams) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text(n.name),
              selected: selected == n.id,
              onSelected: (_) => onSelected(n.id),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day});

  final LedgerDay day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      title: DateFormat('EEE, d MMM yyyy').format(day.date),
      trailing: day.rows.length > 1
          ? Text('${_numbers.format(day.total)} jaap', style: theme.textTheme.labelLarge)
          : null,
      child: Column(
        children: [
          const _ColumnLabels(),
          for (final row in day.rows) _LedgerRowTile(row: row),
        ],
      ),
    );
  }
}

class _ColumnLabels extends StatelessWidget {
  const _ColumnLabels();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text('Jaap name', style: style)),
          SizedBox(width: 76, child: Text('Daily', style: style, textAlign: TextAlign.end)),
          SizedBox(width: 92, child: Text('Total', style: style, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

class _LedgerRowTile extends ConsumerWidget {
  const _LedgerRowTile({required this.row});

  final LedgerRow row;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final entry = row.entry;
    final notifier = ref.read(jaapEntriesProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    await notifier.setCount(entry.dateKey, entry.naamId, 0);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: const Text('Record deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => notifier.setCount(entry.dateKey, entry.naamId, entry.count),
        ),
      ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entry = row.entry;
    final naam = ref.watch(naamByIdProvider(entry.naamId));

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: theme.colorScheme.errorContainer,
        child: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.onErrorContainer),
      ),
      onDismissed: (_) => _delete(context, ref),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showJaapRecordSheet(context, date: parseDateKey(entry.dateKey), naamId: entry.naamId),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.gold.withValues(alpha: 0.2),
                child: Text(
                  (naam?.script ?? '?').characters.first,
                  style: const TextStyle(color: AppColors.maroon, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  naam?.name ?? 'Removed naam',
                  style: theme.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 76,
                child: Text(
                  _numbers.format(entry.count),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              SizedBox(
                width: 92,
                child: Text(
                  _numbers.format(row.runningTotal),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyLog extends StatelessWidget {
  const _EmptyLog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Icon(Icons.menu_book_rounded, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text('Start your jaap log', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Each day you chant appears here with its count and your running total.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SyncBadge extends ConsumerWidget {
  const _SyncBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sync = ref.watch(syncControllerProvider);
    final (icon, label) = switch (sync.status) {
      SyncStatus.synced => (Icons.cloud_done_outlined, 'Saved to Google'),
      SyncStatus.syncing || SyncStatus.connecting => (Icons.cloud_sync_outlined, 'Syncing…'),
      SyncStatus.needsReconnect || SyncStatus.error => (Icons.cloud_off_outlined, 'Sync paused'),
      SyncStatus.signedOut || SyncStatus.unavailable => (Icons.phone_iphone_rounded, 'On this device'),
    };
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Flexible(
          child: Text(label, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
