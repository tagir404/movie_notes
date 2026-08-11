import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/enums/media_sort_option.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/media_genre_filter.dart';
import 'package:movie_notes/widgets/media_sort_filter.dart';
import 'package:movie_notes/widgets/media_type_filter.dart';
import 'package:movie_notes/widgets/swiper_action.dart';

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
    required this.isLoading,
    required this.items,
    required this.selectedGenres,
    required this.selectedSort,
    required this.onTypeChanged,
    required this.onGenresChanged,
    required this.onSortChanged,
    required this.cardBuilder,
    required this.leftActionText,
    required this.rightActionText,
    this.isLoop = true,
    this.onSwipe,
    this.onEnd,
    super.key,
  });

  final MediaContentType initialType;
  final bool isLoading;
  final List<Movie> items;
  final List<int> selectedGenres;
  final MediaSortOption selectedSort;
  final ValueChanged<MediaContentType> onTypeChanged;
  final ValueChanged<List<int>> onGenresChanged;
  final ValueChanged<MediaSortOption> onSortChanged;
  final MediaSwiperCardBuilder cardBuilder;
  final bool isLoop;
  final MediaSwiperOnSwipe? onSwipe;
  final VoidCallback? onEnd;
  final String leftActionText;
  final String rightActionText;

  @override
  State<MediaSwiperView> createState() => _MediaSwiperViewState();
}

class _MediaSwiperViewState extends State<MediaSwiperView> {
  late MediaContentType _selectedType;
  late List<int> _selectedGenres;
  final CardSwiperController _cardSwiperController = CardSwiperController();
  CardSwiperDirection? _swipeDirection;

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
  Widget build(BuildContext context) => Padding(
    padding: const .only(left: 20, right: 20, top: 12, bottom: 12),
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: .spaceBetween,
            children: [
              MediaSortFilter(
                selectedSort: widget.selectedSort,
                onChanged: widget.onSortChanged,
              ),
              MediaGenreFilter(
                genres: AppScope.of(
                  context,
                ).mediaRepository.genres(_selectedType),
                selectedGenres: _selectedGenres,
                onChanged: _handleGenresChanged,
              ),
              MediaTypeFilter(
                selectedType: _selectedType,
                onChanged: _handleTypeChanged,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        Expanded(
          child: widget.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CardSwiper(
                  key: ValueKey(
                    widget.items
                        .map((movie) => '${movie.type.name}-${movie.id}')
                        .join(','),
                  ),
                  padding: const EdgeInsets.all(0),
                  isLoop: widget.isLoop,
                  numberOfCardsDisplayed: widget.items.length == 1 ? 1 : 2,
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
                    setState(() {
                      _swipeDirection = null;
                    });

                    final movie = widget.items[previousIndex];
                    return widget.onSwipe?.call(
                          previousIndex,
                          currentIndex,
                          direction,
                          movie,
                        ) ??
                        true;
                  },
                  onSwipeDirectionChange: (CardSwiperDirection direction, _) {
                    setState(() {
                      _swipeDirection = direction;
                    });
                  },
                  onEnd: widget.onEnd,
                ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            SwiperAction(
              text: widget.leftActionText,
              isActive: _swipeDirection == .left,
              iconOnRight: false,
            ),
            SwiperAction(
              text: widget.rightActionText,
              isActive: _swipeDirection == .right,
              iconOnRight: true,
            ),
          ],
        ),
      ],
    ),
  );
}
