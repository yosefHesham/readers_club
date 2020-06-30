import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final String userName;
  final String imgUrl;
  UserItem({this.imgUrl, this.userName});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imgUrl),
            ),
            title: Text(userName),
          ),
        ),
        Divider()
      ],
    );
  }
}
