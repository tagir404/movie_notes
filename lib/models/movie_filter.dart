class MovieFilter {
  final List<int> genreIds;

  const MovieFilter({this.genreIds = const []});

  bool get hasGenres => genreIds.isNotEmpty;

  MovieFilter copyWith({List<int>? genreIds}) {
    return MovieFilter(genreIds: genreIds ?? this.genreIds);
  }
}
