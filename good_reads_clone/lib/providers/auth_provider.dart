import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_reads_clone/models/user.dart';
import 'package:good_reads_clone/utils/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuthService fbAuth = FirebaseAuthService();
  
  Future<User> signInWithEmailAndPassword(
      String mail, String password, String userName) async {
    final user =
        await fbAuth.signInWithEmailAndPassword(mail, password, userName);
    notifyListeners();
    return user;
  }

  Future<User> createUserWithEmailAndPassword(
      String mail, String password, String userName) async {
    final user =
        await fbAuth.createUserWithEmailAndPassword(mail, password, userName);
    await Firestore.instance.collection('users').document(user.uid).setData({
      'username': userName,
      'imgUrl': user.photoUrl,
    });
    notifyListeners();

    return user;
  }

  Future<User> signInWithFacebook() async {
    final user = await fbAuth.signInWithFacebook();
  
    await Firestore.instance.collection('users').document(user.uid).setData({
      'username': user.displayName,
      'imgUrl': user.photoUrl,
    });
    notifyListeners();
    return user;
  }

  Future<User> signInWithGoogle() async {
    final user = await fbAuth.signInWithGoogle();
    await Firestore.instance.collection('users').document(user.uid).setData({
      'username': user.displayName,
      'imgUrl': user.photoUrl,
    });
    notifyListeners();
    return user;
  }

  Future<void> signOut() async {
    await fbAuth.signOut();
    notifyListeners();
  }

  Future<User> getCurrentUser() async {
    return await fbAuth.currentUser();
  }
}
