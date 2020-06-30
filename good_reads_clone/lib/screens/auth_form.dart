import 'package:flutter/material.dart';
import 'package:good_reads_clone/providers/auth_provider.dart';
import 'package:good_reads_clone/screens/home_page.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  static const routeName = '/auth_form';
  @override
  _AuthFormState createState() => _AuthFormState();
}

enum AuthMode { SignIn, SignUp }

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.SignUp;
  final _formKey = GlobalKey<FormState>();
  FocusNode userFocus;
  FocusNode emailFocus;
  FocusNode passwordFocus;
  FocusNode conPasswordFocus;
  String userName;
  String password;
  String conPassword;
  String email;
  var isLoading = false;
  @override
  void initState() {
    userFocus = FocusNode();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    conPasswordFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    userFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    conPasswordFocus.dispose();
    super.dispose();
  }

  var secText = true;

  /// form submit function
  void _submit(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _formKey.currentState.save();

    if (_formKey.currentState.validate()) {
      /// if the user is registering
      if (_authMode == AuthMode.SignUp) {
        /// try to perform a register and validate it
        try {
          setState(() {
            isLoading = true;
          });
          await auth.createUserWithEmailAndPassword(email, password, userName);
          setState(() {
            isLoading = false;
          });

          /// if everything went well navigate to home page
          Navigator.of(context).popAndPushNamed(HomePage.routeName);

          /// if an error catched show an alert dialog
        } catch (error) {
            var message = error.toString();
            if(message.contains('ALREADY_IN_USE')){
              message = "This mail has been used";
            }
          _showAlertDialog(context, message);

          setState(() {
            isLoading = false;
          });
        }
      }
      // when the user is logging in  try to log him in
      else {
        try {
          setState(() {
            isLoading = true;
          });
          await auth.signInWithEmailAndPassword(email, password, userName);
          isLoading = false;

          /// if everthing went well navigate him
          Navigator.of(context).popAndPushNamed(HomePage.routeName);
        } catch (error) {
          var message = error.toString();
          if(message.contains('USER_NOT_FOUND') || message.contains('WRONG_PASSWORD')){
            message = 'Wrong username or password !';
          }
          else if(message.contains('TOO_MANY_REQUESTS')){
            message = 'login failed many times.. please try again later !';
          }
          _showAlertDialog(context, message);
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  /// build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _authMode == AuthMode.SignIn ? Text('Sign In') : Text('Sign Up'),
        backgroundColor: Colors.grey[500],
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/white.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                ),
              ),
              child: Container(
                width: 150,
                margin: EdgeInsets.only(top: 40),
                height: double.infinity,
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: formFields(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  /// form elements
  List<Widget> formFields() {
    return [
      // User Name Text Field
      _authMode == AuthMode.SignUp
          ? TextFormField(
              initialValue: userName,
              validator: (value) {
                if (value.trim().length == 0 && value.isEmpty) {
                  return "User name cannot be empty !";
                } else if (value.length < 5) {
                  return "user name must be more than 5 characters";
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  userName = value;
                });
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'UserName',
                hintStyle: TextStyle(color: Colors.blueAccent),
              ),
              focusNode: userFocus,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(emailFocus);
              },
            )
          : Container(),
      SizedBox(
        height: 10,
      ),

      // Email Text Field
      TextFormField(
        initialValue: email,
        validator: (value) {
          if (value.trim().length == 0 || value.isEmpty) {
            return "Email cannot be empty !";
          } else if (!value.contains("@") || !value.endsWith('.com')) {
            return "Wrong email !";
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'E-mail',
          hintStyle: TextStyle(color: Colors.blueAccent),
        ),
        keyboardType: TextInputType.emailAddress,
        focusNode: emailFocus,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(passwordFocus);
        },
        onSaved: (value) {
          setState(() {
            email = value.trim();
          });
        },
      ),
      SizedBox(
        height: 10,
      ),

      // Password TextField
      TextFormField(
        initialValue: password,
          validator: (value) {
            if (value.isEmpty) {
              return "password cannot be empty !";
            } else if (value.length < 8) {
              return "short password !";
            }
            return null;
          },
          focusNode: passwordFocus,
          textInputAction: _authMode == AuthMode.SignIn
              ? TextInputAction.done
              : TextInputAction.next,
          decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.blueAccent),
              suffixIcon: IconButton(
                icon: secText == true
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: _changePassowrdVisibility,
              )),
          keyboardType: TextInputType.visiblePassword,
          obscureText: secText,
          onSaved: (value) {
            setState(() {
              password = value;
            });
          },
          onFieldSubmitted: (_) {
            _authMode == AuthMode.SignUp
                ? FocusScope.of(context).requestFocus(conPasswordFocus)
                : _submit(context);
          }),
      SizedBox(
        height: 10,
      ),

      // checking which authmode and adding ConfirmPasswordTextField if it`s Sign up
      _authMode == AuthMode.SignUp
          ? TextFormField(
            initialValue: conPassword,
              validator: (value) {
                if (value != password) {
                  return "Password does not match !";
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(context),
              onSaved: (value) {
                setState(() {
                  conPassword = value;
                });
              },
              textInputAction: TextInputAction.done,
              focusNode: conPasswordFocus,
              obscureText: secText,
              decoration: InputDecoration(
                  hintText: 'ConfirmPassword',
                  hintStyle: TextStyle(color: Colors.blueAccent),
                  suffixIcon: IconButton(
                    icon: secText == true
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: _changePassowrdVisibility,
                  )),
            )
          : Container(),

      // submit Button
      Container(
        width: 150,
        margin: EdgeInsets.only(top: 10),
        child: RaisedButton(
          color: Color(141414).withOpacity(.4),
          child: Text(
            _authMode == AuthMode.SignIn ? 'Log In' : 'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          onPressed: () => _submit(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          splashColor: Colors.red,
        ),
      ),

      /// Change AuthMode Button
      Text(_authMode == AuthMode.SignUp
          ? "Have an account?"
          : 'don`t have an account?'),
      InkWell(
          child: Text(
            _authMode == AuthMode.SignUp ? 'Log in' : 'Sign Up',
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
          onTap: _changeAuthMode)
    ];
  }

  /// Switch between sign in and sign up
  void _changeAuthMode() {
    if (_authMode == AuthMode.SignIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.SignIn;
      });
    }
  }

  void _changePassowrdVisibility() {
    setState(() {
      secText = !secText;
    });
  }

  /// showing error message
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
