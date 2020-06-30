import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/book.dart';
import 'package:good_reads_clone/providers/data_provider.dart';
import 'package:good_reads_clone/widgets/book_card.dart';
import 'package:good_reads_clone/widgets/drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  /// variables to manage the UI
  var _isSearching = false;
  var _istyping = false;
  var searchDone = false;
  final key = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<BooksProvider>(context);
    List<Book> books = data.books;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blueGrey),
          leading:

              /// if the user starts typing in the textfield show the back button
              _istyping
                  ? BackButton(
                      color: Colors.blueGrey,
                      onPressed: () {
                        /// when the back button is pressed show the menue
                        setState(() {
                          _istyping = false;
                          _isSearching = false;
                          searchDone = false;
                        });
                      },
                    )
                  : null,
          backgroundColor: Colors.grey[700],
          title: _buildTextField(),
        ),
        drawer: MyDrawer(),

        /// if the book is empty show one of the following
        body: books.isEmpty
            ? Center(
                /// if the user is searching show him an indicator and if the search is done and the list is empty tell him that
                child: _isSearching
                    ? CircularProgressIndicator()
                    : Text(searchDone
                        ? "No Matching result"
                        : "Find any book by a click !"),
              )

            /// after searching and the result was not empty
            : SafeArea(
                child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Search Result: ${books.length}',
                                textAlign: TextAlign.start,
                              ),

                              /// this is an option to clear the search result
                              FlatButton.icon(
                                icon: Icon(
                                  Icons.clear,
                                  size: 15,
                                ),
                                label: Text(
                                  'Clear',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  data.clear();
                                  setState(() {
                                    searchDone = false;
                                  });
                                },
                              ),
                            ])),
                    Container(
                      height: 500,

                      /// building the book card
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            childAspectRatio: .7,
                            crossAxisSpacing: 5),
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: books[i], child: BookCard()),
                        itemCount: books.length,
                      ),
                    ),
                    Divider()
                  ],
                ),
              )));
  }

  /// function to get the data
  void _fetchData(BuildContext context, String item) async {
    /// if the textfield is not empty try to get the data
    if (key.currentState.validate()) {
      final fetch = Provider.of<BooksProvider>(context, listen: false);
      // preparing the ui for a new search
      fetch.clear();
      setState(() {
        _isSearching = true;
      });
      try {
        await fetch.fetchData(item);
        setState(() {
          _isSearching = false;
        });
        setState(() {
          searchDone = true;
        });
      }

      /// handling common exceptions
      catch (error) {
        var message = error.toString();
        if (message.contains("404")) {
          message = "Error 404 not found !";
        } else if (message.contains("Failed host lookup")) {
          message = "please check your connection !";
        }
        _showAlertDialog(context, message);
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  /// building our search app bar
  Widget _buildTextField() {
    return Container(
      height: 50,
      child: TextFormField(
        key: key,
        validator: (value) {
          if (value.trim().length == 0 || value.isEmpty) {
            return "Cannot be empty !";
          }
          return null;
        },
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (_) {
          _fetchData(context, _searchController.text);
          _searchController.clear();
        },
        controller: _searchController,
        style: TextStyle(color: Colors.white),
        onTap: () {
          setState(() {
            _istyping = true;
          });
        },
        autofocus: false,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.cyan,
            hintText: "Search books",
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                _searchController.clear();
              },
              iconSize: 35,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                gapPadding: 20,
                borderSide: BorderSide(
                    color: Colors.white, width: 1, style: BorderStyle.solid)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                    color: Colors.white, width: 1, style: BorderStyle.solid))),
      ),
    );
  }

  /// showing error message
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
