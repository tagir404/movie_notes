String formatRuntime(int minutes) {
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;

  if (hours == 0) return '$remainingMinutes мин';

  if (remainingMinutes == 0) return '$hours ч';

  return '$hours ч $remainingMinutes мин';
}

String formatCount(int count) {
  String format(double value, String suffix) {
    final result = value.toStringAsFixed(1);
    return '${result.endsWith('.0') ? result.substring(0, result.length - 2) : result}$suffix';
  }

  if (count >= 1000000) return format(count / 1000000, 'м');

  if (count >= 1000) return format(count / 1000, 'т');

  return count.toString();
}
