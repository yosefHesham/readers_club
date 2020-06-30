import 'package:meta/meta.dart';

@immutable
class User{
  final String uid;
  final String photoUrl;
  final String displayName;
  final String email;
  const User({
    @required this.uid,
    this.photoUrl,
    this.displayName,
    this.email
  });
}