import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/widgets/media_genre_filter.dart';
import 'package:movie_notes/widgets/media_type_filter.dart';

typedef MediaSwiperCardBuilder =
    Widget Function(
      BuildContext context,
      Movie movie,
      MediaContentType selectedType,
      List<int> selectedGenres,
    );

typedef MediaSwiperOnSwipe =
    bool Function(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      Movie movie,
    );

class MediaSwiperView extends StatefulWidget {
  const MediaSwiperView({
    required this.initialType,
    required this.emptyMessage,
    required this.isLoading,
    required this.items,
    required this.genresForType,
    required this.selectedGenres,
    required this.onTypeChanged,
    required this.onGenresChanged,
    required this.cardBuilder,
    required this.leftAction,
    required this.rightAction,
    this.onSwipe,
    this.onEnd,
    super.key,
  });

  final MediaContentType initialType;
  final String emptyMessage;
  final bool isLoading;
  final List<Movie> items;
  final List<Genre> Function(MediaContentType type) genresForType;
  final List<int> selectedGenres;
  final ValueChanged<MediaContentType> onTypeChanged;
  final ValueChanged<List<int>> onGenresChanged;
  final MediaSwiperCardBuilder cardBuilder;
  final Widget leftAction;
  final Widget rightAction;
  final MediaSwiperOnSwipe? onSwipe;
  final VoidCallback? onEnd;

  @override
  State<MediaSwiperView> createState() => _MediaSwiperViewState();
}

class _MediaSwiperViewState extends State<MediaSwiperView> {
  late MediaContentType _selectedType;
  late List<int> _selectedGenres;
  final CardSwiperController _cardSwiperController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedGenres = List.of(widget.selectedGenres);
  }

  @override
  void didUpdateWidget(covariant MediaSwiperView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialType != widget.initialType) {
      _selectedType = widget.initialType;
    }

    if (!listEquals(oldWidget.selectedGenres, widget.selectedGenres)) {
      _selectedGenres = List.of(widget.selectedGenres);
    }
  }

  void _handleTypeChanged(MediaContentType type) {
    setState(() {
      _selectedType = type;
    });
    widget.onTypeChanged(type);
  }

  void _handleGenresChanged(List<int> genres) {
    setState(() {
      _selectedGenres = genres;
    });
    widget.onGenresChanged(genres);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.items.isEmpty) {
      return Center(child: Text(widget.emptyMessage));
    }

    return Padding(
      padding: const .only(left: 20, right: 20, top: 0, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MediaTypeFilter(
                selectedType: _selectedType,
                onChanged: _handleTypeChanged,
              ),
              MediaGenreFilter(
                genres: widget.genresForType(_selectedType),
                selectedGenres: _selectedGenres,
                onChanged: _handleGenresChanged,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CardSwiper(
              padding: const EdgeInsets.all(0),
              isLoop: false,
              numberOfCardsDisplayed: 2,
              backCardOffset: const Offset(0, 0),
              scale: 1,
              controller: _cardSwiperController,
              allowedSwipeDirection: const .symmetric(
                horizontal: true,
                vertical: false,
              ),
              cardsCount: widget.items.length,
              cardBuilder: (context, index, _, _) {
                final movie = widget.items[index];
                return widget.cardBuilder(
                  context,
                  movie,
                  _selectedType,
                  _selectedGenres,
                );
              },
              onSwipe: (previousIndex, currentIndex, direction) {
                if (currentIndex == null) return true;
                final movie = widget.items[currentIndex];
                return widget.onSwipe?.call(
                      previousIndex,
                      currentIndex,
                      direction,
                      movie,
                    ) ??
                    true;
              },
              onEnd: widget.onEnd,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.leftAction,
              const SizedBox(width: 24),
              widget.rightAction,
            ],
          ),
        ],
      ),
    );
  }
}
