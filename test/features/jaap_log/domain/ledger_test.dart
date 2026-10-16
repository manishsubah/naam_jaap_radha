import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/data/models/jaap_entry.dart';
import 'package:naam_jaap/features/jaap_log/domain/ledger.dart';

JaapEntry _e(String day, String naam, int count, {bool deleted = false}) =>
    JaapEntry(dateKey: day, naamId: naam, count: count, updatedAt: DateTime(2026), deleted: deleted);

void main() {
  final entries = [
    _e('2026-10-01', 'radha', 108),
    _e('2026-10-02', 'radha', 216),
    _e('2026-10-02', 'ram', 54),
    _e('2026-10-03', 'radha', 108),
    _e('2026-10-03', 'ram', 999, deleted: true),
  ];

  test('groups by day, newest first', () {
    final days = buildLedger(entries);
    expect(days.map((d) => d.dateKey), ['2026-10-03', '2026-10-02', '2026-10-01']);
    expect(days[1].total, 270);
  });

  test('running total is per naam and includes that day', () {
    final days = buildLedger(entries);
    int totalOf(String day, String naam) =>
        days.firstWhere((d) => d.dateKey == day).rows.firstWhere((r) => r.entry.naamId == naam).runningTotal;
    expect(totalOf('2026-10-01', 'radha'), 108);
    expect(totalOf('2026-10-02', 'radha'), 324);
    expect(totalOf('2026-10-03', 'radha'), 432);
    expect(totalOf('2026-10-02', 'ram'), 54);
  });

  test('skips deleted records', () {
    final oct3 = buildLedger(entries).first;
    expect(oct3.rows.map((r) => r.entry.naamId), ['radha']);
  });

  test('filtering by naam keeps the full running total', () {
    final days = buildLedger(entries, naamId: 'radha');
    expect(days.every((d) => d.rows.every((r) => r.entry.naamId == 'radha')), isTrue);
    expect(days.first.rows.single.runningTotal, 432);
  });

  test('totalBefore excludes the day itself', () {
    expect(totalBefore(entries, 'radha', '2026-10-02'), 108);
    expect(totalBefore(entries, 'radha', '2026-10-01'), 0);
  });
}
