import 'package:flutter/material.dart';
import 'package:movie_notes/models/genre.dart';

class MovieFilterWidget extends StatelessWidget {
  const MovieFilterWidget({
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
    return Material(
      color: Colors.black,
      borderRadius: .circular(20),
      elevation: 6,
      child: InkWell(
        borderRadius: .circular(20),
        splashColor: Colors.white24,
        splashFactory: InkSparkle.splashFactory,
        highlightColor: Colors.white10,
        onTap: () => _showGenres(context),
        child: Stack(
          clipBehavior: .none,
          children: [
            const Padding(
              padding: .symmetric(horizontal: 12, vertical: 8),
              child: Text('Жанры', style: TextStyle(color: Colors.white)),
            ),

            if (selectedGenres.isNotEmpty)
              Positioned(
                top: -6,
                right: -6,
                child: Material(
                  color: Colors.red,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Text(
                        selectedGenres.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showGenres(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        var selected = [...selectedGenres];

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const .all(16),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        const Text(
                          'Выберите жанры',
                          style: TextStyle(fontSize: 18, fontWeight: .bold),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selected.clear();
                            });
                          },
                          child: const Text('Сбросить'),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      children: genres.map((genre) {
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
                      }).toList(),
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
                        child: const Text('Применить'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
