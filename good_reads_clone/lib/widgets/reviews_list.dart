import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/reviews.dart';
import 'package:good_reads_clone/providers/reviews_provider.dart';
import 'package:good_reads_clone/widgets/review_item.dart';
import 'package:provider/provider.dart';

class ReviewsScreen extends StatefulWidget {
  String id;
  ReviewsScreen(this.id);
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  var _reviewController = TextEditingController();
  var isRevLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(5),
            child: TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  hintText: 'submit your review',
                  suffixIcon: isRevLoading
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(
                            Icons.save,
                            color: Colors.blueGrey,
                            size: 30,
                          ),
                          onPressed: () async => await _submitReview(
                              Review(
                                  bookId: widget.id,
                                  review: _reviewController.text,
                                  date: DateTime.now().toString()),
                              context),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                  ),
                ))),
        FutureBuilder(
          future: Provider.of<ReviewsProvider>(
            context,
            listen: false,
          ).fetchReviews(widget.id),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              _showAlertDialog(context, snapshot.error.toString());
            } else {
              return Consumer<ReviewsProvider>(
                builder: (ctx, reviews, _) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: reviews.reviews[i],
                    child: ReviewItem(),
                  ),
                  itemCount: reviews.reviews.length,
                ),
              );
            }
            return null;
          },
        )
      ],
    );
  }

  _showAlertDialog(BuildContext context, String message) {
    final _alert = AlertDialog(
      title: Text("An Error Occured"),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    showDialog(context: context, builder: (context) => _alert);
  }

  Future<void> _submitReview(Review review, BuildContext context) async {
    if (_reviewController.text.trim().length > 0 &&
        _reviewController.text != null) {
      try {
        setState(() {
          isRevLoading = true;
        });
        await Provider.of<ReviewsProvider>(context, listen: false)
            .addReview(review);
        setState(() {
          isRevLoading = false;
          _reviewController.clear();
        });
      } catch (error) {
        _showAlertDialog(context, error.toString());
      }
    } else {
      _showAlertDialog(context, 'review cannot be empty !');
    }
  }
}
