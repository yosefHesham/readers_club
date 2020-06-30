import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/book.dart';
import 'package:good_reads_clone/providers/auth_provider.dart';
import 'package:good_reads_clone/providers/bookshelft.dart';
import 'package:good_reads_clone/widgets/reviews_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetails extends StatefulWidget {
  static const routeName = 'book_details';
  String imgUrl;
  String author;
  String title;
  String id;
  String description;
  num ratingCount;
  num averageRating;
  int length;
  BookDetails(
      {this.imgUrl,
      this.author,
      this.description,
      this.ratingCount,
      this.title,
      this.averageRating,
      this.id,
      this.length});
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  /// to store the book id which is added to bookshelf
  List<String> added = List<String>();
  var isLoading = false;
  var _isInit = false;
  var isRevLoading = false;

  @override
  void initState() {
    setState(() {
      _isInit = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      added = await _getPrefData(context);
      setState(() {
      _isInit = false;
    });
    }
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.blueGrey.withOpacity(.5),
        elevation: .5,
      ),
      body: SafeArea(
        /// column to display book details
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              /// book image
              Hero(
                  tag: widget.id,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              widget.imgUrl,
                            ),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(.9),
                                BlendMode.srcATop))),
                    padding: EdgeInsets.only(bottom: 10, top: 2),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .4,
                    child: Center(
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(5),
                        child: ClipRRect(
                          child: Image.network(widget.imgUrl, fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  )),
              // book title
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      width: 320,
                      child: Text(
                        '${widget.title}',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // book author
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'by: ',
                    style: TextStyle(color: Colors.teal),
                  ),
                  Text('${widget.author}'),
                ],
              ),

              // creating v space
              SizedBox(
                height: 5,
              ),
              Divider(
                indent: 15,
                color: Colors.grey,
                endIndent: 15,
              ),
              SizedBox(
                height: 5,
              ),
              // rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: widget.averageRating > 0
                        ? _buildRatingStars()
                        : <Widget>[Text('N/F')],
                  ),
                  Text('  .${widget.ratingCount}')
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // button to add the book to the book shelf
              isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton.icon(
                      onPressed: () {
                        /// the book is on user`s bookshelf? so remove it it !

                        (added != null && added.contains(widget.id))
                            ? _removeFromBookshelf(context, widget.id)
                            : _addToBookShelf(
                                Book(
                                    id: widget.id,
                                    title: widget.title,
                                    author: widget.author,
                                    description: widget.description,
                                    ratingCount: widget.ratingCount,
                                    averageCount: widget.averageRating,
                                    imgUrl: widget.imgUrl),
                                context);

                        // it`s aleady on
                      },
                      icon: (added != null && added.contains(widget.id))
                          ? Icon(Icons.done)
                          : Icon(Icons.add),
                      label: (added != null && added.contains(widget.id))
                          ? Text('Added')
                          : Text('Add To Bookshelf'),
                      color: Colors.indigo,
                      textColor: Colors.white,
                    ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.grey,
                indent: 15,
                endIndent: 15,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.tealAccent)),
                padding: EdgeInsets.all(10),
                child: Text(widget.description),
              ),
              Divider(
                indent: 5,
                endIndent: 5,
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text('Leave a review !'),
              ),
              
                ReviewsScreen(widget.id),
            ])),
      ),
    );
  }

  List<Icon> _buildRatingStars() {
    List<Icon> icons = [];
    for (int i = 0; i < widget.averageRating; i++) {
      icons.add(Icon(
        Icons.star,
        color: Colors.cyan,
        size: 15,
      ));
    }
    return icons;
  }

  /// then function is called when the user clicks the add to bookshelf button
  Future<void> _addToBookShelf(Book book, BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      final user = await Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUser();
      final shelf = Provider.of<BookShelf>(context, listen: false);
      await shelf.addToBookShelf(user.uid, book);

      var pref = await SharedPreferences.getInstance();
      added = await _getPrefData(context);
      added = added == null ? List<String>() : added;
      added.add(book.id);
      await pref.setStringList(user.uid, added);
      added = await _getPrefData(context);

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      _showAlertDialog(context, error.toString());
    }
  }

  /// this alert dialog will be displayed whenever an error occurs
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

  // this function will be called when the user open the book detail screen for the first time
  // by calling it it will check if book is already added in the bookshelf or not
  Future<List<String>> _getPrefData(BuildContext context) async {
    // storing the user as a key and the book id as the value
    final user = await Provider.of<AuthProvider>(context, listen: false)
        .getCurrentUser();
    var pref = await SharedPreferences.getInstance();
    print(pref.getStringList(user.uid));
    return pref.getStringList(user.uid);
  }

  /// this function will be called if the user clicked on added button
  Future<void> _removeFromBookshelf(BuildContext context, String id) async {
    try {
      setState(() {
        isLoading = true;
      });
      final user = await Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUser();
      await Provider.of<BookShelf>(context, listen: false)
          .deleteFromBookShelf(user.uid, id);
      var pref = await SharedPreferences.getInstance();
      added = await _getPrefData(context);

      setState(() {
        added.removeWhere((element) => element == id);
        isLoading = false;
      });
      await pref.setStringList(user.uid, added);
    } catch (error) {
      _showAlertDialog(context, error.toString());
      isLoading = false;
    }
  }

  
}
