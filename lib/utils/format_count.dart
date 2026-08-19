import 'package:flutter/widgets.dart';

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
