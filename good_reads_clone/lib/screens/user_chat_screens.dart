import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:good_reads_clone/widgets/user_item.dart';

class UsersList extends StatelessWidget {
  static const routeName = '/users_list';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder<QuerySnapshot>(
            future: _usersList(),
            builder: (ctx, snap) =>
                ConnectionState.waiting == snap.connectionState
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: snap.data.documents.length,
                        itemBuilder: (ctx, i) => UserItem(
                              userName: snap.data.documents[i]['username'],
                              imgUrl: snap.data.documents[i]['imgUrl'] == null ? '':snap.data.documents[i]['imgUrl'],
                            )),
          ),
        ));
  }
}

Future<QuerySnapshot> _usersList() {
  return Firestore.instance.collection('users').getDocuments();
}
