class GenreFilter {
  final List<int> genreIds;

  const GenreFilter({this.genreIds = const []});

  bool get hasGenres => genreIds.isNotEmpty;

  GenreFilter copyWith({List<int>? genreIds}) {
    return GenreFilter(genreIds: genreIds ?? this.genreIds);
  }
}
