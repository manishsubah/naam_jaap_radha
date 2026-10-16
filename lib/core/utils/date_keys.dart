String dateKey(DateTime date) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${date.year.toString().padLeft(4, '0')}-${two(date.month)}-${two(date.day)}';
}

DateTime parseDateKey(String key) => DateTime.parse(key);

DateTime dayOnly(DateTime date) => DateTime(date.year, date.month, date.day);

int computeStreak(Map<String, int> dailyTotals, DateTime today) {
  var day = dayOnly(today);
  if ((dailyTotals[dateKey(day)] ?? 0) == 0) {
    day = DateTime(day.year, day.month, day.day - 1);
  }
  var streak = 0;
  while ((dailyTotals[dateKey(day)] ?? 0) > 0) {
    streak++;
    day = DateTime(day.year, day.month, day.day - 1);
  }
  return streak;
}
