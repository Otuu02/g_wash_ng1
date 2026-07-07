// FILE: lib/presentation/widgets/rating_stars.dart
// PURPOSE: Interactive star rating widget

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RatingStars extends StatefulWidget {
  final double initialRating;
  final double size;
  final Function(double)? onRatingChanged;
  final bool interactive;
  
  const RatingStars({
    super.key,
    this.initialRating = 0,
    this.size = 32,
    this.onRatingChanged,
    this.interactive = true,
  });
  
  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late double _rating;
  
  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        return GestureDetector(
          onTap: widget.interactive
              ? () {
                  setState(() {
                    _rating = starValue;
                  });
                  widget.onRatingChanged?.call(starValue);
                }
              : null,
          child: Icon(
            starValue <= _rating ? Icons.star : Icons.star_border,
            size: widget.size,
            color: starValue <= _rating ? Colors.amber : AppColors.grey400,
          ),
        );
      }),
    );
  }
}