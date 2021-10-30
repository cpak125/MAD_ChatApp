import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ConvoRatingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RatingBar(
      ratingWidget: RatingWidget(
          full: Icon(Icons.star, color: Colors.orange),
          half: Icon(
            Icons.star_half,
            color: Colors.orange,
          ),
          empty: Icon(
            Icons.star_outline,
            color: Colors.orange,
          )),
      itemSize: 30.0,
      initialRating: 0,
      allowHalfRating: true,
      itemCount: 5,
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
