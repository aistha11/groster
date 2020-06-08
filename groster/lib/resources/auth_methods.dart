// import 'dart:io';

import 'package:groster/constants/strings.dart';
// import 'package:groster/enum/auth_state.dart';
import 'package:groster/enum/user_state.dart';
import 'package:groster/models/user.dart';
import 'package:groster/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  static final Firestore _firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;

  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<FirebaseUser> getCurrentUser() async {
    try{
      FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<User> getUserDetails() async {
    try{
      FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();
    return User.fromMap(documentSnapshot.data);
    }catch(e){
      print("Error while getiing user detail");
      print(e);
      return null;
    }
  }

  Future<User> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.document(id).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      var result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print("Auth methods error");
      print(e);
      return null;
    }
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    User user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.document(userId).updateData({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.document(uid).snapshots();
}

// class AuthMethods with ChangeNotifier {
//   FirebaseUser _user;
//   Status _status = Status.Uninitialized;
//   static final Firestore _firestore = Firestore.instance;
//   final FirebaseAuth _auth;
//   GoogleSignIn _googleSignIn = GoogleSignIn();
//   // static final Firestore firestore = Firestore.instance;
//   //Constructor
//   AuthMethods.instance()
//       : _auth = FirebaseAuth.instance,
//         _googleSignIn = GoogleSignIn() {
//     _auth.onAuthStateChanged.listen(_onAuthStateChanged);
//   }
//   //Setter and getter
//   Status get status => _status;
//   FirebaseUser get user => _user;

//   Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
//     if (firebaseUser == null) {
//       _status = Status.Unauthenticated;
//     } else {
//       _user = firebaseUser;
//       print("State Changed");
//       _status = Status.Authenticated;
//     }
//     notifyListeners();
//   }

//   //get users collection
//   static final CollectionReference _userCollection =
//       _firestore.collection(USERS_COLLECTION);
//   //get current User
//   Future<FirebaseUser> getCurrentUser() async {
//     FirebaseUser currentUser;
//     currentUser = await _auth.currentUser();
//     return currentUser;
//   }

//   //get current user details
//   Future<User> getUserDetails() async {
//     FirebaseUser currentUser = await getCurrentUser();

//     DocumentSnapshot documentSnapshot =
//         await _userCollection.document(currentUser.uid).get();
//     return User.fromMap(documentSnapshot.data);
//   }

//   //get users details by Id
//   Future<User> getUserDetailsById(id) async { 
//     try {
//       DocumentSnapshot documentSnapshot =
//           await _userCollection.document(id).get();
//       return User.fromMap(documentSnapshot.data);
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   //Sign In with Google
//   Future<FirebaseUser> signInWithGoogle() async {
//     try {
//        _status = Status.Authenticating;
//       notifyListeners(); 
//       GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
//       GoogleSignInAuthentication _signInAuthentication =
//           await _signInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.getCredential(
//           accessToken: _signInAuthentication.accessToken,
//           idToken: _signInAuthentication.idToken);

//       AuthResult result = await _auth.signInWithCredential(credential);
//       FirebaseUser newuser = result.user;
//       print(newuser.email);
      
//       return newuser;
//     } catch (e) {
//       print(e);
//        _status = Status.Unauthenticated;
//       notifyListeners();
//       return null;
//     }
//   }
//   //Sign in with Email and Password
//   Future<bool> signIn(String email, String password) async {
//     try {
//       _status = Status.Authenticating;
//       notifyListeners();
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       // addDataToDb(_user);
//       return true;
//     } catch (e) {
//       _status = Status.Unauthenticated;
//       notifyListeners();
//       return false;
//     }
//   }
//   //Sign Up with Email and Password
//   Future<bool> signUp(String email, String password) async {
//     try {
//       _status = Status.Authenticating;
//       notifyListeners();
//       await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       print(_user.email);
//       // addDataToDb(_user);
//       return true;
//     } catch (e) {
//       _status = Status.Unauthenticated;
//       notifyListeners();
//       return false;
//     }
//   }

//   //To check whether the user is already registered or not
//   Future<bool> authenticateUser(FirebaseUser user) async {
//     QuerySnapshot result = await _firestore
//         .collection(USERS_COLLECTION)
//         .where(EMAIL_FIELD, isEqualTo: user.email)
//         .getDocuments();

//     final List<DocumentSnapshot> docs = result.documents;

//     //if user is registered then length of list > 0 or else less than 0
//     return docs.length == 0 ? true : false;
//   }

//   //To add the users details to firestore db after registering
//   Future<void> addDataToDb(FirebaseUser currentUser) async {
//     // var currentUser = _user;
//     print(currentUser.uid);
//     print(currentUser.email);
//     print(currentUser.displayName);
//     print(currentUser.photoUrl);
//     String username = Utils.getUsername(currentUser.email);
//     print(username);
//     User user = User(
//       uid: currentUser.uid,
//       email: currentUser.email,
//       name: currentUser.displayName,
//       profilePhoto: currentUser.photoUrl,
//       username: username,
//     );
//     await _firestore
//         .collection(USERS_COLLECTION)
//         .document(currentUser.uid)
//         .setData(user.toMap(user));
//   }
//   //To retrieve all users excluding the current user
//   Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
//     List<User> userList = List<User>();

//     QuerySnapshot querySnapshot =
//         await _firestore.collection(USERS_COLLECTION).getDocuments();
//     for (var i = 0; i < querySnapshot.documents.length; i++) {
//       if (querySnapshot.documents[i].documentID != currentUser.uid) {
//         userList.add(User.fromMap(querySnapshot.documents[i].data));
//       }
//     }
//     return userList;
//   }
//   //Logout the user
//   Future<bool> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//       // // set userState to offline as the user logs out'
//       //   setUserState(
//       //     userId: user.uid,
//       //     userState: UserState.Offline,
//       //   );
//       _status = Status.Unauthenticated;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       print(e);
//       return false;
//     }
//   }
//   //To set the user status
//   void setUserState({@required String userId, @required UserState userState}) {
//     int stateNum = Utils.stateToNum(userState);

//     _userCollection.document(userId).updateData({
//       "state": stateNum,
//     });
//   }
//   //To get stream of users
//   Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
//       _userCollection.document(uid).snapshots();

  
// }
