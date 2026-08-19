import 'package:material_ui/material_ui.dart';
import 'package:movie_match/l10n/app_localizations.dart';

class MediaEmptyState extends StatelessWidget {
  const MediaEmptyState({required this.onReset, super.key});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const .all(24),
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(
              l10n.media_empty,
              textAlign: .center,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8),
            Text(
              l10n.media_empty_filtered_hint,
              textAlign: .center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),
            FilledButton(
              onPressed: onReset,
              child: Text(l10n.filter_reset_all),
            ),
          ],
        ),
      ),
    );
  }
}
