import 'package:good_reads_clone/models/user.dart';
abstract class AuthService{
  
  Future<User> currentUser();
  Future<User> createUserWithEmailAndPassword(String email, String password, String userName);
  Future<User> signInWithEmailAndPassword(String email, String passwrod, String userName);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
    
}