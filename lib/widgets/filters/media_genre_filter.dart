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
  Widget build(BuildContext context) => Stack(
    clipBehavior: .none,
    children: [
      Pill(
        onTap: () => _showGenres(context),
        borderRadius: .circular(20),
        padding: const .symmetric(horizontal: 12, vertical: 4),
        child: Text(
          AppLocalizations.of(context)!.filter_genres,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      if (selectedGenres.isNotEmpty)
        Positioned(
          top: -6,
          right: -6,
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            elevation: 4,
            child: SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: Text(
                  '${selectedGenres.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
    ],
  );

  void _showGenres(BuildContext context) {
    var selected = [...selectedGenres];

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
                      AppLocalizations.of(context)!.filter_choose_genres,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(selected.clear);
                      },
                      child: Text(AppLocalizations.of(context)!.filter_reset),
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
                    child: Text(AppLocalizations.of(context)!.filter_apply),
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
