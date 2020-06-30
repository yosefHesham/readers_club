import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/user.dart';
import 'package:good_reads_clone/providers/auth_provider.dart';
import 'package:good_reads_clone/screens/auth_screen.dart';
import 'package:good_reads_clone/screens/book_shelf_screen.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future:
          Provider.of<AuthProvider>(context, listen: false).getCurrentUser(),
      builder: (ctx, snap) {
        return Consumer<AuthProvider>(
          builder: (context, auth, _) => Container(
            color: Colors.blueAccent,
            child: Drawer(
              elevation: 2,
              child: Container(
                color: Colors.blueGrey,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      color: Colors.blueGrey,
                      height: 160,
                      child: DrawerHeader(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {},
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(snap.data.photoUrl == null? '':snap.data.photoUrl),
                                    radius: 35,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    snap.data.displayName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Welcome !",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.bookmark),
                      title: Text('your books'),
                      onTap: () async {
                        Navigator.of(context)
                            .popAndPushNamed(BookShelfScreen.routeName);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Log out'),
                      onTap: () async {
                        await auth.signOut();
                        Navigator.of(context)
                            .popAndPushNamed(AuthenticationScreen.name);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
