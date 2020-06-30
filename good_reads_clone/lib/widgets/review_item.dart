import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/reviews.dart';
import 'package:provider/provider.dart';



class ReviewItem extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Consumer<Review>(
        builder: (ctx, review, _) => Column(
              children: <Widget>[
               
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: review.imgUrl == null
                        ? AssetImage('assets/images/anuser.jpg')
                        : NetworkImage(review.imgUrl),
                    radius: 20,
                  ),
                  title: Text(
                    review.name,
                    style: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(review.date),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Text(review.review, textAlign: TextAlign.center,)),
                Divider()
              ],
            ));
  }

  
}
