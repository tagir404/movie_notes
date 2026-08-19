import 'package:flutter/widgets.dart';
import 'package:movie_match/l10n/app_localizations.dart';

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
