import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_reads_clone/providers/auth_provider.dart';
import 'package:good_reads_clone/providers/bookshelft.dart';
import 'package:good_reads_clone/widgets/book_shelf_item.dart';
import 'package:provider/provider.dart';

class BookShelfScreen extends StatefulWidget {
  static const routeName = '/bookshelf';

  @override
  _BookShelfScreenState createState() => _BookShelfScreenState();
}

class _BookShelfScreenState extends State<BookShelfScreen> {
  var _isInit = false;
  var user;
  var isLoading = false;

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
      setState(() {
        isLoading = true;
      });

      final auth = await Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUser();

      user = auth.uid;

      await Provider.of<BookShelf>(context, listen: false).getBooks(user);
      setState(() {
        _isInit = false;
        isLoading = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final shelf = Provider.of<BookShelf>(context, listen: true);
    final books = shelf.books;
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Books!'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : books.isEmpty? Center(child: Text('You havnt addded any book yet'),): ListView.builder(
                itemCount: books.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: books[i],
                  child: BookShelfItem(),
                ),
              ));
  }
}
