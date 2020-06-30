import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:good_reads_clone/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'auth_form.dart';

class AuthenticationScreen extends StatefulWidget {
  static const name = '/';
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String font = 'Liberation';
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/white.jpg'),
                      fit: BoxFit.cover)),
              child: Container(
                height: double.infinity,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        'Readers',
                        style: TextStyle(
                            fontFamily: 'Liberation',
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text('CLUB',
                              style: TextStyle(
                                  fontFamily: 'Liberation',
                                  fontSize: 50,
                                  letterSpacing: 4,
                                  color: Color(141414).withOpacity(1),
                                  fontWeight: FontWeight.bold))),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        authButton(
                            'Continue With Facebook',
                            Buttons.Facebook,
                            Color(141414).withOpacity(.4),
                            Colors.white,
                            Colors.white,
                            signInWithFacebook),
                        authButton(
                            'Continue With Gmail',
                            Buttons.GoogleDark,
                            Color(141414).withOpacity(.4),
                            Colors.white,
                            Colors.white,
                            signInWithGoogle),
                        authButton(
                            'Sign Up With E-mail',
                            Buttons.Email,
                            Color(141414).withOpacity(.4),
                            Colors.white,
                            Colors.white,
                            emailSignUp),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void emailSignUp(BuildContext context) {
    Navigator.of(context).pushNamed(AuthForm.routeName);
  }

  Widget authButton(String method, Buttons icon, Color color, Color textColor,
      Color iconColor, Function clicked) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SignInButton(
        icon,
        text: method,
        onPressed: () {
          return clicked(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        mini: false,
        color: color,
        textColor: textColor,
        iconColor: iconColor,
      ),
    );
  }

  void signInWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      final user = await auth.signInWithFacebook();
      if (user == null) {
        _showAlertDialog(
            context, "Missing Auth Token.. Please Check Your Connection !");
        setState(() {
          isLoading = false;
        });
      }
    } on PlatformException catch (error) {
      _showAlertDialog(context, error.message);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      _showAlertDialog(
          context, 'Missing Auth Token.. Please Check Your Connection !');
      setState(() {
        isLoading = false;
      });
    }
  }

  void signInWithGoogle(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await auth.signInWithGoogle().catchError((onError) {
      var message ='';
      if(onError.toString().contains('ABORTED_BY_USER')){
        message = 'Cancelled by user !';
      _showAlertDialog(context, message);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  _showAlertDialog(BuildContext context, String message) {
    final _alert = AlertDialog(
      title: Text("An Error Occured"),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    showDialog(context: context, builder: (context) => _alert);
  }
}
