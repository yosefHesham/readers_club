import 'package:flutter/cupertino.dart';

class Book with ChangeNotifier{
  
  String author;
  String title;
  String id;
  String imgUrl;
  String description;
  num ratingCount;
  num averageCount;

  Book({ @required this.id, this.author, this.title,this.imgUrl,this.averageCount,this.ratingCount,this.description});

  
}