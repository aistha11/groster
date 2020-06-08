import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groster/constants/strings.dart';
import 'package:groster/enum/auth_state.dart';
import 'package:groster/models/user.dart';
import 'package:groster/resources/auth_methods.dart';
import 'package:groster/utils/utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class UserRepository with ChangeNotifier { 
  FirebaseAuth _auth;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;
  User _fuser;
  Status _status = Status.Uninitialized;

  AuthMethods authMethods = AuthMethods();


  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  User get getUser => _fuser;

  Future<void> refreshUser() async {
    User user = await authMethods.getUserDetails();
    _fuser = user;
    notifyListeners(); 
  }

  Future<void> addDataToFdb(FirebaseUser newUser) async {
    String username = Utils.getUsername(newUser.email);

    User user = User(
        uid: newUser.uid,
        email: newUser.email,
        name: "No Name",
        profilePhoto: "https://fertilitynetworkuk.org/wp-content/uploads/2017/01/Facebook-no-profile-picture-icon-620x389.jpg",
        username: username);

    Firestore.instance
        .collection(USERS_COLLECTION)
        .document(newUser.uid)
        .setData(user.toMap(user));

  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("Error While Sign In");
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    // AuthMethods authMethods = AuthMethods();
    try {
      _status = Status.Authenticating;
      notifyListeners();
       await _auth.createUserWithEmailAndPassword(
          email: email, password: password).then((result){
            if(result.user != null){
              authMethods.authenticateUser(result.user).then((isNewUser){
                if(isNewUser)
                  addDataToFdb(result.user);
              });
            }
          });
      return true;
    } catch (e) {
      print(e.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  // Future<bool> signInWithGoogle() async {
  //   try {
  //     _status = Status.Authenticating;
  //     notifyListeners();
  //     final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     await _auth.signInWithCredential(credential);
  //     addDataToFdb(_user);
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
