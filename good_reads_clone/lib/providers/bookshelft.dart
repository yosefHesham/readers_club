import 'package:flutter/cupertino.dart';
import 'package:good_reads_clone/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookShelf with ChangeNotifier {
  List<Book> _books = [];

  Future<void> addToBookShelf(String uid, Book book) async {
    try {
      await Firestore.instance
          .collection('bookShelf')
          .document(uid)
          .collection("books")
          .document(book.id)
          .setData({
        'title': book.title,
        'author': book.author,
        'ratingCount': book.ratingCount,
        'averageCount': book.averageCount,
        'imgUrl': book.imgUrl,
        'description': book.description
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteFromBookShelf(String uid, String id) async {
    await Firestore.instance
        .collection('bookShelf')
        .document(uid)
        .collection('books')
        .document(id)
        .delete();
    _books.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> getBooks(String uid) async {
    final data = await Firestore.instance
        .collection('bookShelf')
        .document(uid)
        .collection('books')
        .getDocuments();
    final List<Book> books = [];

    if (data.documents.length > 0) {
      data.documents.forEach((doc) {
        final book = Book(
            id: doc.documentID,
            title: doc['title'],
            author: doc['author'],
            imgUrl: doc['imgUrl'],
            description: doc['description'],
            ratingCount: doc['ratingCount'],
            averageCount: doc['averageCount']);
        print(book);
        books.add(book);
      });
      _books = books;
      notifyListeners();
    }
  }

  List<Book> get books {
    return [..._books];
  }
}
