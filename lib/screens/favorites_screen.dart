import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/genre_filter.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/media_swiper_view.dart';
import 'package:movie_notes/widgets/movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  MediaContentType _selectedType = MediaContentType.movie;
  GenreFilter _genreFilter = const GenreFilter();
  final Map<int, MovieDetails> _movieDetails = {};

  Future<void> _loadMovieDetails(Movie movie) async {
    if (_movieDetails.containsKey(movie.id)) return;

    final movieRepository = AppScope.of(context).movieRepository;
    final details = await movieRepository.getMovieDetails(movie.id, movie.type);

    if (!mounted) return;

    setState(() {
      _movieDetails[movie.id] = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRepository = AppScope.of(context).favoriteRepository;
    final movieRepository = AppScope.of(context).movieRepository;
    final mediaList = favoriteRepository.getFavorites();

    return Scaffold(
      appBar: AppBar(title: const Text('Сохранённые')),
      body: FutureBuilder(
        future: mediaList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет сохраненных элементов.'));
          }

          final movies = snapshot.data!
              .where((movie) => movie.type == _selectedType)
              .where((movie) {
                if (_genreFilter.genreIds.isEmpty) return true;
                return movie.genreIds.any(
                  (genreId) => _genreFilter.genreIds.contains(genreId),
                );
              })
              .toList();

          return MediaSwiperView(
            initialType: _selectedType,
            emptyMessage: 'Нет сохраненных элементов.',
            isLoading: false,
            items: movies,
            genresForType: movieRepository.genres,
            selectedGenres: _genreFilter.genreIds,
            onTypeChanged: (type) {
              setState(() {
                _selectedType = type;
              });
            },
            onGenresChanged: (genreIds) {
              setState(() {
                _genreFilter = _genreFilter.copyWith(genreIds: genreIds);
              });
            },
            cardBuilder: (context, movie, selectedType, selectedGenres) {
              _loadMovieDetails(movie);

              final movieGenres = movie.genreIds
                  .map(
                    (id) => movieRepository
                        .genres(selectedType)
                        .firstWhere((genre) => genre.id == id),
                  )
                  .toList();

              return MovieCard(
                key: ValueKey(movie.id),
                movie: movie,
                genres: movieGenres,
                selectedGenreIds: selectedGenres,
                movieDetails: _movieDetails[movie.id],
              );
            },
            leftActionInfo: Row(
              spacing: 8,
              children: [
                const Icon(Icons.swipe_left, size: 16),
                Text('', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            rightActionInfo: Row(
              spacing: 8,
              children: [
                Text('', style: Theme.of(context).textTheme.bodyMedium),
                const Icon(Icons.swipe_right, size: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
