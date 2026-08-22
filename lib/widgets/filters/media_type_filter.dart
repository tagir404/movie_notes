import 'package:material_ui/material_ui.dart';
import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/widgets/pill.dart';
import '../../l10n/app_localizations.dart';

class MediaTypeFilter extends StatelessWidget {
  const MediaTypeFilter({
    required this.selectedType,
    required this.onChanged,
    super.key,
  });

  final MediaContentType selectedType;
  final ValueChanged<MediaContentType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Pill(
            onTap: () => onChanged(.movie),
            borderRadius: const .only(
              topLeft: .circular(20),
              bottomLeft: .circular(20),
            ),
            padding: const .symmetric(horizontal: 12, vertical: 4),
            color: selectedType == .movie ? theme.colorScheme.primary : null,
            child: Text(
              textAlign: .center,
              l10n.media_type_movies,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: selectedType == .movie
                    ? theme.colorScheme.onPrimary
                    : null,
              ),
            ),
          ),
        ),

        Expanded(
          child: Pill(
            onTap: () => onChanged(.tvShow),
            borderRadius: const .only(
              topRight: .circular(20),
              bottomRight: .circular(20),
            ),
            padding: const .symmetric(horizontal: 12, vertical: 4),
            color: selectedType == .tvShow ? theme.colorScheme.primary : null,
            child: Text(
              l10n.media_type_tv_shows,
              textAlign: .center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: selectedType == .tvShow
                    ? theme.colorScheme.onPrimary
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
