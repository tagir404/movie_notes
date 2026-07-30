String formatRuntime(int minutes) {
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;

  if (hours == 0) return '$remainingMinutes мин';

  if (remainingMinutes == 0) return '$hours ч';

  return '$hours ч $remainingMinutes мин';
}
