import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/book.dart';
import 'package:good_reads_clone/screens/book_details.dart';
import 'package:provider/provider.dart';

class BookCard extends StatelessWidget {
  
  

  @override
  Widget build(BuildContext context) {
    return Consumer<Book>(
        builder: (ctx, book, _) => InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookDetails(
                        id: book.id,
                        title: book.title,
                        author: book.author,
                        imgUrl: book.imgUrl,
                        ratingCount: book.ratingCount,
                        averageRating: book.averageCount,
                        description: book.description,
                      ))),
              child: GridTile(
                  child: Hero(
                    tag: book.id,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(book.imgUrl),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.tealAccent,
                          shape: BoxShape.rectangle),
                    ),
                  ),
                  footer: Container(
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: book.averageCount > 0
                            ? _buildRatingStars(book.averageCount)
                            : <Widget>[
                                Text(
                                  'No Rating',
                                  style: TextStyle(color: Colors.redAccent),
                                )
                              ]),
                  )),
            ));
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
}
