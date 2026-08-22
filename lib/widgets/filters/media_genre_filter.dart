import 'package:material_ui/material_ui.dart';
import 'package:movie_match/models/genre.dart';
import 'package:movie_match/widgets/pill.dart';
import '../../l10n/app_localizations.dart';

class MediaGenreFilter extends StatelessWidget {
  const MediaGenreFilter({
    required this.genres,
    required this.selectedGenres,
    required this.onChanged,
    super.key,
  });

  final List<Genre> genres;
  final List<int> selectedGenres;
  final ValueChanged<List<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      clipBehavior: .none,
      children: [
        Pill(
          onTap: () => _showGenres(context),
          borderRadius: .circular(20),
          padding: const .symmetric(horizontal: 12, vertical: 4),
          child: Text(l10n.filter_genres, style: theme.textTheme.bodyLarge),
        ),
        if (selectedGenres.isNotEmpty)
          Positioned(
            top: -6,
            right: -6,
            child: Material(
              color: theme.colorScheme.primary,
              shape: const CircleBorder(),
              elevation: 4,
              child: SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: Text(
                    '${selectedGenres.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showGenres(BuildContext context) {
    var selected = [...selectedGenres];
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const .all(16),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      l10n.filter_choose_genres,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(selected.clear);
                      },
                      child: Text(l10n.filter_reset),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    final genre = genres[index];

                    return CheckboxListTile(
                      title: Text(genre.name),
                      value: selected.contains(genre.id),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selected.add(genre.id);
                          } else {
                            selected.remove(genre.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: const .all(16),
                child: SizedBox(
                  width: .infinity,
                  child: FilledButton(
                    onPressed: () {
                      onChanged(selected);
                      Navigator.pop(context);
                    },
                    child: Text(l10n.filter_apply),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
