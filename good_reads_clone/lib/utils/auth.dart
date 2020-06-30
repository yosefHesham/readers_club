import 'package:flutter/services.dart';
import 'package:good_reads_clone/models/user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:good_reads_clone/utils/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// function parse the firebase user to a user model
  User _fromFirebaseUser(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
        uid: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        email: user.email);
  }

  // creating new account
  @override
  Future<User> createUserWithEmailAndPassword(
      String mail, String password, String userName) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: mail, password: password);
    final fbsu = result.user;
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = userName;
    userUpdateInfo.photoUrl = fbsu.photoUrl;
    await fbsu.updateProfile(userUpdateInfo);
    await fbsu.reload();
    return _fromFirebaseUser(fbsu);
  }

  /// retrieving current logged in user
  @override
  Future<User> currentUser() async {
    FirebaseUser fuser = await _auth.currentUser();
    if (fuser != null) {
      return _fromFirebaseUser(fuser);
    }
    return null;
  }

  /// email and password logging in
  @override
  Future<User> signInWithEmailAndPassword(
      String mail, String password, String userName) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: mail, password: password);
      final fbsu = result.user;
      return _fromFirebaseUser(fbsu);
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final fblogin = FacebookLogin();
    final result = await fblogin.logIn(['email']);

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
    );
    final AuthResult user = (await _auth.signInWithCredential(credential));
    return _fromFirebaseUser(user.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    /// creating an instance of google sign in
    final GoogleSignIn googleSignIn = GoogleSignIn();

    /// logging in to google account

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    /// if the user logged in succesfully it will authenticate it with our app
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      /// linking the user to firebase servers
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final AuthResult authResult = await _auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return _fromFirebaseUser(authResult.user);

        /// if the auth token is not found an error will be displayed
      } else {
        throw PlatformException(
            code: "ERROR_MISSING_GOOGLE_AUTH_TOKEN",
            message: "Missing Google Auth Token");
      }
      //if the user cancelled the signing in operation
    } else {
      throw PlatformException(
          code: "ERROR_ABORTED_BY_USER", message: "Sign in aborted by user");
    }
  }

  @override
  Future<void> signOut() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    } else if (await facebookLogin.isLoggedIn) {
      await facebookLogin.logOut();
    }
    await _auth.signOut();
  }
}
