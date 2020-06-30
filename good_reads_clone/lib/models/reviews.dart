import 'package:flutter/foundation.dart';

class Review with ChangeNotifier{
  final String name;
  final String userId;
  final String bookId;
  final String review;
  final String date;
  final String imgUrl;
  Review({this.name,this.userId,this.bookId,this.date,this.imgUrl,this.review});


}