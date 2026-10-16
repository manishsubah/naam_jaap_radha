import 'package:naam_jaap/core/utils/date_keys.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';

/// One record in the jaap log: a day's count for a naam, plus that naam's
/// running total up to and including that day.
class LedgerRow {
  const LedgerRow({required this.entry, required this.runningTotal});

  final JaapEntry entry;
  final int runningTotal;
}

class LedgerDay {
  const LedgerDay({required this.dateKey, required this.rows});

  final String dateKey;
  final List<LedgerRow> rows;

  DateTime get date => parseDateKey(dateKey);

  int get total => rows.fold(0, (sum, r) => sum + r.entry.count);
}

/// Groups entries by day (newest first). Running totals are always computed
/// over every entry of a naam, so filtering by [naamId] hides rows without
/// changing the totals shown.
List<LedgerDay> buildLedger(Iterable<JaapEntry> entries, {String? naamId}) {
  final live = entries.where((e) => !e.deleted && e.count > 0).toList()
    ..sort((a, b) => a.dateKey.compareTo(b.dateKey));

  final running = <String, int>{};
  final byDay = <String, List<LedgerRow>>{};
  for (final e in live) {
    final total = running[e.naamId] = (running[e.naamId] ?? 0) + e.count;
    if (naamId != null && e.naamId != naamId) continue;
    (byDay[e.dateKey] ??= []).add(LedgerRow(entry: e, runningTotal: total));
  }

  final keys = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final key in keys)
      LedgerDay(
        dateKey: key,
        rows: byDay[key]!..sort((a, b) => b.entry.count.compareTo(a.entry.count)),
      ),
  ];
}

/// The naam's total from all days before [dateKey]; used to preview the
/// running total while a record is being edited.
int totalBefore(Iterable<JaapEntry> entries, String naamId, String dateKey) => entries
    .where((e) => !e.deleted && e.naamId == naamId && e.dateKey.compareTo(dateKey) < 0)
    .fold(0, (sum, e) => sum + e.count);
