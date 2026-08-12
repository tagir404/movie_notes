import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

String formatRuntime(BuildContext context, int minutes) {
  final loc = AppLocalizations.of(context);
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;

  if (hours == 0) {
    return '$remainingMinutes ${loc!.runtime_minutes_abbreviation}';
  }

  if (remainingMinutes == 0) return '$hours ${loc!.runtime_hours_abbreviation}';

  return '$hours ${loc!.runtime_hours_abbreviation} $remainingMinutes ${loc.runtime_minutes_abbreviation}';
}

String formatCount(BuildContext context, int count) {
  String format(double value, String suffix) {
    final result = value.toStringAsFixed(1);
    return '${result.endsWith('.0') ? result.substring(0, result.length - 2) : result}$suffix';
  }

  final language = Localizations.localeOf(context).languageCode;

  final thousand = language == 'ru' ? 'т' : 'K';
  final million = language == 'ru' ? 'м' : 'M';

  if (count >= 1000000) return format(count / 1000000, million);

  if (count >= 1000) return format(count / 1000, thousand);

  return count.toString();
}
