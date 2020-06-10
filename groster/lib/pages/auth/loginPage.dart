import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groster/enum/auth_state.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  bool signInForm;

  @override
  void initState() {
    super.initState();
    signInForm = true;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    //Asynchronous Function For Firebase Login
    googleSignIn() async {
      print('Login With Google');
      await user.signInWithGoogle(context);
      // print(currentuser.uid);
      // print(currentuser.email);
      // print(currentuser.displayName);
      // print(currentuser.photoUrl);
      // if(currentuser!=null){
      //   user.authenticateUser(currentuser).then((isNewUser){
      //     if(isNewUser)
      //       user.addDataToDb(currentuser);
      //     // print("Added user to db");
      //   });
      // }
    }

    facebookSignIn() async {
      print('Login With Facebook');
      await user.signUpWithFacebook(context);
    }

    return WillPopScope(
      onWillPop: () async {
        if (!signInForm) {
          setState(() {
            signInForm = true;
          });
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: _key,
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Column(
              children: [
                //App Name or Logo
                Container(
                  height: signInForm ? 200.0 : 180.0,
                  decoration: BoxDecoration(
                    // color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(80.0),
                        bottomRight: Radius.circular(80.0)),
                  ),
                  // child: Center(
                  //   child: Text(
                  //     'Family App List',
                  //     style: TextStyle(fontSize: 27.0),
                  //   ),
                  // ),
                  child: Image.asset("images/grocery2.jpg",fit: BoxFit.cover),
                ),
                //Loading Progress Bar while Authenticating
                user.status == Status.Authenticating
                    ? Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ))
                    : Padding(padding: EdgeInsets.all(1.0)),
                //Form for login or SignIn
                AnimatedSwitcher(
                  child: signInForm ? SignIn() : SignUp(),
                  duration: Duration(milliseconds: 200),
                ),
                //Divider
                Divider(
                  thickness: 3.0,
                  color: Colors.red,
                  indent: 120.0,
                  endIndent: 120.0,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    //Login With Google
                    buildButton('google', FontAwesomeIcons.google,
                        Colors.orange, Colors.lime, googleSignIn),
                    //Login With Facebook
                    buildButton('facebook', FontAwesomeIcons.facebook,
                        Colors.indigo, Colors.blue, facebookSignIn),
                  ],
                ),
                //Sign Up
                OutlineButton(
                  textColor: Colors.black,
                  child: signInForm
                      ? Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      : Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      signInForm = !signInForm;
                    });
                  },
                  color: Colors.grey,
                  borderSide: BorderSide(color: Colors.indigoAccent),
                  highlightColor: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String platForm, IconData icon, Color iconColor,
      Color bgCol, Function func) {
    return Container(
      height: 55.0,
      // margin: EdgeInsets.only(left: 40.0),
      padding: EdgeInsets.all(10.0),
      width: 160.0,
      child: RaisedButton.icon(
        onPressed: func,
        icon: Icon(
          icon,
          color: iconColor,
          size: 19.0,
        ),
        label: Text(
          '$platForm',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 3,
        color: bgCol,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ),
        ),
      ),
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FocusNode passwordField = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email;
  TextEditingController _password;
  bool _obscure;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _obscure = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            //Login
            Icon(
              FontAwesomeIcons.peopleCarry,
              size: 50.0,
            ),
            //Username
            Container(
              margin: EdgeInsets.only(left: 40, right: 40.0, top: 30.0),
              color: Colors.grey[200],
              child: TextFormField(
                validator: (val) {
                  return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)
                      ? null
                      : "*Enter correct email";
                },
                controller: _email,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'youremail@gmail.com',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                ),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(passwordField);
                },
              ),
            ),
            //Password
            Container(
              margin: EdgeInsets.only(left: 40, right: 40.0, top: 20.0),
              child: TextFormField(
                validator: (val) {
                  if (val.isEmpty) return "*Password is required";
                  return null;
                },
                controller: _password,
                obscureText: _obscure,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: _obscure
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  ),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                ),
              ),
            ),
            //Login Button
            const SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.pink,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              textColor: Colors.white,
              child: Text("Login"),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (!await user.signIn(_email.text, _password.text))
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Error'),
                        content: Text("Sorry we cann't log into your account now"),
                      ),
                      barrierDismissible: true,
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode lastName = FocusNode();
  final FocusNode emailField = FocusNode();
  final FocusNode passwordField = FocusNode();
  final FocusNode confirmPasswordField = FocusNode();
  TextEditingController _fName;
  TextEditingController _lName;
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _confirmPassword;
  bool _obscure;
  bool _obscureConform;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _fName = TextEditingController();
    _lName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _obscure = true;
    _obscureConform = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            //SignUp
            // Icon(
            //   FontAwesomeIcons.peopleCarry,
            //   size: 50.0,
            // ),
            //First Name
            Container(
              margin: EdgeInsets.only(left: 40, right: 40.0, top: 10.0),
              child: TextFormField(
                validator: (val) {
                  if(val.isEmpty) return "*Enter your First Name";
                  return null;
                },
                controller: _fName,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.person),
                  hintText: 'First Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                ),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(lastName);
                },
              ),
            ),
            //Last Name
            Container(
              margin: EdgeInsets.only(left: 40, right: 40.0, top: 10.0),
              child: TextFormField(
                validator: (val) {
                  if(val.isEmpty) return "*Enter your Last Name";
                  return null;
                },
                controller: _lName,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.person),
                  hintText: 'Last Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                ),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(emailField);
                },
              ),
            ),
            //Username
            Container(
              margin: EdgeInsets.only(left: 40, right: 40.0, top: 10.0),
              child: TextFormField(
                validator: (val) {
                  return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)
                      ? null
                      : "*Enter correct email";
                },
                controller: _email,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'youremail@gmail.com',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                ),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(passwordField);
                },
              ),
            ),
            //Password
            Container(
              margin: EdgeInsets.only(left: 40, right: 40.0, top: 10.0),
              child: TextFormField(
                validator: (val) {
                  if (val.isEmpty) return "*Password is required";
                  return null;
                },
                controller: _password,
                obscureText: _obscure,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: _obscure
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  ),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                ),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(confirmPasswordField);
                },
              ),
            ),
            //Conform Password
            Container(
              margin: EdgeInsets.only(left: 40, right: 40.0, top: 10.0),
              child: TextFormField(
                validator: (val) {
                  if (val.isEmpty) return "*Confirm Password is required";
                  return null;
                },
                controller: _confirmPassword,
                obscureText: _obscureConform,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: _obscureConform
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConform = !_obscureConform;
                      });
                    },
                  ),
                  hintText: 'Confirm Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                ),
              ),
            ),
            //Login Button
            const SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.pink,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              textColor: Colors.white,
              child: Text("Create Account"),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (_confirmPassword.text == _password.text) {
                    String name = "${_fName.text} ${_lName.text}";
                    if (!await user.signUp(context, _email.text, _password.text, name))
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Error'),
                          content: Text("Sorry we cann't create account now"),
                        ),
                        barrierDismissible: true,
                      );
                  } else
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Error'),
                        content:
                            Text("Password and Conform Password doesn't match"),
                      ),
                      barrierDismissible: true,
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
