import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/book.dart';

class BooksProvider with ChangeNotifier {
  var apiKey = 'AIzaSyA9yMVvxWwADV57ZPAS7vuiCcTvR0LKV1Y';
  List<Book> _books = [];
  get books {
    return [..._books];
  }

  /// function to fetch data
  Future<void> fetchData(String item) async {
    var url = 'https://www.googleapis.com/books/v1/volumes?maxResults=40&q=$item&key=$apiKey';
    try {
      final res = await http.get(url);

      /// extracting the json to this list
      final List<Book> loadedBooks = [];
      final data = jsonDecode(res.body)['items'] as List<dynamic>;

      /// if the data is not empty so it will sotre the data into the list
      print(data[0]['volumeInfo']['description']);
      if (data != null && data.isNotEmpty) {
        data.asMap().forEach((key, bookData) {
          loadedBooks.add(Book(
              id: bookData['id'],
              author: bookData['volumeInfo']['authors'] == null
                  ? "Unkown"
                  : bookData['volumeInfo']['authors'][0],
              title: bookData['volumeInfo']['title'],
              averageCount: bookData['volumeInfo']['averageRating'] == null
                  ? 0
                  : bookData['volumeInfo']['averageRating'],
              ratingCount: bookData['volumeInfo']['ratingsCount'] == null
                  ? 0
                  : bookData['volumeInfo']['ratingsCount'],
              imgUrl: bookData['volumeInfo']['imageLinks'] != null
                  ? bookData['volumeInfo']['imageLinks']['thumbnail']
                  : " ",
              description: bookData['volumeInfo']['description'] == null
                  ? "Not Provided"
                  : bookData['volumeInfo']['description']));
        });
        _books = loadedBooks;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  /// funciton to clear the lists
  void clear() {
    _books.clear();
    notifyListeners();
  }
}
