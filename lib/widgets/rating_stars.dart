import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({required this.rating, super.key});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final filledStars = rating.floor();
    final hasHalfStar = rating - filledStars >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: List.generate(10, (index) {
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
