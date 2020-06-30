import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/reviews.dart';

class ReviewsProvider with ChangeNotifier {
  List<Review> _reviews = [];

  Future<void> addReview(Review review) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      await Firestore.instance
          .collection('reviews')
          .document(review.bookId)
          .collection('users')
          .document(user.uid)
          .setData({
        'review': review.review,
        'date': review.date,
        'imgUrl': user.photoUrl == null ? null : user.photoUrl,
        'userName': user.displayName
      });
      _reviews.add(review);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchReviews(String bookId) async {
    try {
      _reviews = [];
      final data = await Firestore.instance
          .collection('reviews')
          .document(bookId)
          .collection('users')
          .getDocuments();
      List<Review> reviews = [];
      print("## doc length # ${data.documents.length}");
      if (data.documents.length > 0) {
        data.documents.forEach((rev) {
          final review = Review(
            userId: rev.documentID,
            bookId: bookId,
            review: rev['review'],
            date: rev['date'].toString(),
            imgUrl: rev['imgUrl'],
            name: rev['userName'],
          );
          reviews.add(review);
        });
        _reviews = reviews;
        print("## her is my length ${_reviews.length}");
        notifyListeners();
      }
      
    } catch (error) {
      throw error;
    }
  }

  List<Review> get reviews {
    return [..._reviews];
  }
  void clearList(){
    _reviews.clear();
  }
}
