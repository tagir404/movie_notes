import 'package:material_ui/material_ui.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/widgets/swiper_action.dart';

typedef MediaSwiperCardBuilder =
    Widget Function(BuildContext context, Movie movie);

typedef MediaSwiperOnSwipe =
    bool Function(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      Movie movie,
    );

class MediaSwiperView extends StatefulWidget {
  const MediaSwiperView({
    required this.items,
    required this.cardBuilder,
    required this.leftActionText,
    required this.rightActionText,
    this.isLoop = true,
    this.onSwipe,
    this.onEnd,
    super.key,
  });

  final List<Movie> items;
  final MediaSwiperCardBuilder cardBuilder;
  final bool isLoop;
  final MediaSwiperOnSwipe? onSwipe;
  final VoidCallback? onEnd;
  final String leftActionText;
  final String rightActionText;

  @override
  State<MediaSwiperView> createState() => MediaSwiperViewState();
}

class MediaSwiperViewState extends State<MediaSwiperView> {
  final CardSwiperController _cardSwiperController = CardSwiperController();
  CardSwiperDirection? _swipeDirection;

  void undo() {
    _cardSwiperController.undo();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: CardSwiper(
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

            return widget.cardBuilder(context, movie);
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
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          SwiperAction(
            text: widget.leftActionText,
            isActive: _swipeDirection == .left,
            iconAfterText: false,
          ),
          SwiperAction(
            text: widget.rightActionText,
            isActive: _swipeDirection == .right,
            iconAfterText: true,
          ),
        ],
      ),
    ],
  );
}
