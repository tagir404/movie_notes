import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({required this.rating, super.key});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final fiveStarRating = rating / 2;

    final filledStars = fiveStarRating.floor();
    final hasHalfStar = fiveStarRating - filledStars >= 0.5;

    return Row(
      mainAxisSize: .min,
      spacing: 2,
      children: List.generate(5, (index) {
        if (index < filledStars) {
          return const Icon(Icons.star, size: 18, color: Colors.amber);
        }

        if (index == filledStars && hasHalfStar) {
          return const Icon(Icons.star_half, size: 18, color: Colors.amber);
        }

        return Icon(
          Icons.star_border,
          size: 18,
          color: Colors.white.withValues(alpha: 0.7),
        );
      }),
    );
  }
}
