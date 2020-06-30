import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/book.dart';
import 'package:good_reads_clone/providers/auth_provider.dart';
import 'package:good_reads_clone/providers/bookshelft.dart';
import 'package:good_reads_clone/screens/book_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookShelfItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Consumer<Book>(
              builder: (ctx, book, _) => ListTile(
                  leading: Container(
                      width: 100,
                      height: 200,
                      child: Image.network(
                        book.imgUrl,
                        fit: BoxFit.fill,
                      )),
                  title: Text(book.title),
                  isThreeLine: true,
                  subtitle: Row(
                    children: <Widget>[
                      Row(
                        children: _buildRatingStars(book.averageCount),
                      ),
                      Text('${book.ratingCount}')
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeFromBookshelf(context, book.id),
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => BookDetails(
                            author: book.author,
                            title: book.title,
                            imgUrl: book.imgUrl,
                            ratingCount: book.ratingCount,
                            averageRating: book.averageCount,
                            description: book.description,
                            id: book.id,
                          )))),
            )));
  }

  List<Icon> _buildRatingStars(num averageRating) {
    List<Icon> icons = [];
    for (int i = 0; i < averageRating; i++) {
      icons.add(Icon(
        Icons.star,
        color: Colors.cyan,
        size: 15,
      ));
    }
    return icons;
  }

  Future<void> _removeFromBookshelf(BuildContext context, String id) async {
    try {
      final user = await Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUser();
      await Provider.of<BookShelf>(context, listen: false)
          .deleteFromBookShelf(user.uid, id);
      var pref = await SharedPreferences.getInstance();
      List<String> added = pref.getStringList(user.uid);
      
      added.removeWhere((element) => element == id);

      await pref.setStringList(user.uid, added);
    } catch (error) {
      _showAlertDialog(context, error.toString());
    }
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
}
