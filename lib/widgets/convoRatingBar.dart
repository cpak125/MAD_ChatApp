import 'package:chatapp/models/user.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ConvoRatingBar extends StatefulWidget {
  final String convoId;
  final double rating;
  final UserEX peer;
  const ConvoRatingBar(
      {Key? key,
      required this.convoId,
      required this.rating,
      required this.peer})
      : super(key: key);

  @override
  _ConvoRatingBarState createState() => _ConvoRatingBarState();
}

class _ConvoRatingBarState extends State<ConvoRatingBar> {
  void _submitRating(double rating) {
    Database.submitConvoRating(widget.convoId, rating, widget.peer);
  }

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
      allowHalfRating: true,
      itemCount: 5,
      initialRating: widget.rating,
      onRatingUpdate: (rating) {
        setState(() {
          _submitRating(rating);
        });
      },
    );
  }
}
