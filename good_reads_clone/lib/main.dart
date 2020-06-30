import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/user.dart';
import 'package:good_reads_clone/providers/auth_provider.dart';
import 'package:good_reads_clone/providers/bookshelft.dart';
import 'package:good_reads_clone/providers/data_provider.dart';
import 'package:good_reads_clone/providers/reviews_provider.dart';
import 'package:good_reads_clone/screens/book_details.dart';
import 'package:good_reads_clone/screens/book_shelf_screen.dart';
import 'package:good_reads_clone/screens/bottom_navbar.dart';
import 'package:good_reads_clone/screens/home_page.dart';
import 'package:good_reads_clone/screens/user_chat_screens.dart';
import 'screens/auth_form.dart';
import 'screens/auth_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: BooksProvider()),
        ChangeNotifierProvider.value(value: BookShelf()),
        ChangeNotifierProvider.value(value: ReviewsProvider())
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: "GoodReads",
          home: FutureBuilder<User>(
              future: auth.getCurrentUser(),
              builder: (context, snap) {
                return snap.data != null ? BottomNav(): AuthenticationScreen();
              }),
          routes: {
            AuthForm.routeName: (context) => AuthForm(),
            HomePage.routeName: (context) => HomePage(),
            BookDetails.routeName: (context) => BookDetails(),
            BookShelfScreen.routeName: (context) => BookShelfScreen(),
            UsersList.routeName: (context) => UsersList()
          },
        ),
      ),
    );
  }
}
