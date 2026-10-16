import 'package:flutter_test/flutter_test.dart';
import 'package:naam_jaap/core/utils/date_keys.dart';

void main() {
  group('computeStreak', () {
    final today = DateTime(2026, 3, 10);
    String daysAgo(int n) => dateKey(DateTime(2026, 3, 10 - n));

    test('counts consecutive days including today', () {
      final totals = {daysAgo(0): 108, daysAgo(1): 50, daysAgo(2): 1, daysAgo(4): 10};
      expect(computeStreak(totals, today), 3);
    });

    test('keeps yesterday streak alive when today is empty', () {
      final totals = {daysAgo(1): 108, daysAgo(2): 108};
      expect(computeStreak(totals, today), 2);
    });

    test('is zero when there is no recent jaap', () {
      expect(computeStreak({daysAgo(3): 108}, today), 0);
    });
  });
}
