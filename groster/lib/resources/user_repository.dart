import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:groster/constants/strings.dart';
import 'package:groster/enum/auth_state.dart';
import 'package:groster/enum/user_state.dart';
import 'package:groster/models/user.dart';
import 'package:groster/utils/func.dart';
import 'package:groster/utils/utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  GoogleSignIn _googleSignIn;
  Muser _fuser;
  Status _status = Status.Uninitialized;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;
  Muser get getUser => _fuser;

  Future<User> getCurrentUser() async {
    try {
      User currentUser;
      currentUser = _auth.currentUser;
      return currentUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> refreshUser() async {
    Muser ruser = await getUserDetails();
    _fuser = ruser;
    notifyListeners();
  }

  Future<Muser> getUserDetails() async {
    try {
      User currentUser = await getCurrentUser();

      DocumentSnapshot documentSnapshot =
          await _userCollection.doc(currentUser.uid).get();
      return Muser.fromMap(documentSnapshot.data());
    } catch (e) {
      print("Error while getiing user detail");
      print(e);
      return _fuser;
    }
  }

  Future<Muser> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.doc(id).get();
      return Muser.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.doc(uid).snapshots();

  Future<bool> authenticateUser(User nuser) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: nuser.email)
        .where("uid", isEqualTo: nuser.uid)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    Muser muser = Muser(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoURL,
        username: username);

    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(muser.toMap(muser));
  }

  Future<bool> updateFamily(String familyName, String familyId) async {
    try {
      Muser upuser = Muser(
        uid: getUser.uid,
        email: getUser.email,
        name: getUser.name,
        profilePhoto: getUser.profilePhoto,
        username: getUser.username,
        familyName: familyName,
        familyId: familyId,
      );
      await firestore
          .collection(USERS_COLLECTION)
          .doc(user.uid)
          .update(upuser.toMap(upuser));
      refreshUser();
      notifyListeners();
      return true;
    } catch (e) {
      print("Updating");
      print(e.toString());
      return false;
    }
  }

  Future<bool> leaveFamily(Muser upuser) async {
    try {
      await firestore
          .collection(USERS_COLLECTION)
          .doc(user.uid)
          .update(upuser.toMap(upuser));
      refreshUser();
      notifyListeners();
      return true;
    } catch (e) {
      print("Updating");
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateProfile(Muser upUser) async {
    refreshUser();
    try {
      //   User upuser = User(
      //   uid: getUser.uid,
      //   email: getUser.email,
      //   name: name,
      //   profilePhoto: photoUrl,
      //   username: getUser.username,
      //   familyName: getUser.familyName,
      //   familyId: getUser.familyId,
      // );
      await firestore
          .collection(USERS_COLLECTION)
          .doc(user.uid)
          .update(upUser.toMap(upUser));
      refreshUser();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> addDataToFdb(User newUser, String name) async {
    String username = Utils.getUsername(newUser.email);

    Muser muser = Muser(
        uid: newUser.uid,
        email: newUser.email,
        name: name,
        profilePhoto: BLANK_IMAGE,
        username: username);

    FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(newUser.uid)
        .set(muser.toMap(muser));
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

  Future<bool> signUp(
      BuildContext context, String email, String password, String name) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        if (result.user != null) {
          authenticateUser(result.user).then((isNewUser) {
            if (isNewUser) addDataToFdb(result.user, name);
          });
        }
      });
      return true;
    } catch (e) {
      Func.showError(context, e.toString());
      print(e.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signInWithGoogle(context) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      await _auth.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          authenticateUser(value.user).then((isNewUser) {
            if (isNewUser) addDataToDb(value.user);
          });
        }
      });
    } catch (e) {
      Func.showError(context, "Error While Sign In With Google");
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      // return null;
    }
  }

  // //FaceBook Login
  // Future<void> signUpWithFacebook(context) async {
  //   _status = Status.Authenticating;
  //   notifyListeners();
  //   FacebookLogin fbLogin = FacebookLogin();
  //   fbLogin.logIn(['email', 'public_profile']).then((result) {
  //     if (result.status == FacebookLoginStatus.loggedIn) {
  //       final AuthCredential credential = FacebookAuthProvider.getCredential(
  //         accessToken: result.accessToken.token,
  //       );
  //       _auth.signInWithCredential(credential).then((result) {
  //         if (result.user != null) {
  //           authenticateUser(result.user).then((isNewUser) {
  //             if (isNewUser) addDataToDb(result.user);
  //           });
  //         }
  //       }).catchError((e) {
  //         print(e.toString());
  //         _status = Status.Unauthenticated;
  //         notifyListeners();
  //         return false;
  //       });
  //     }
  //   }).catchError((e) {
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     return false;
  //   });
  // }

  Future<Null> signUpWithFacebook(context) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;
          final AuthCredential credential =
              FacebookAuthProvider.credential(result.accessToken.token);
          print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
          await _auth.signInWithCredential(credential).then((value) {
            if (value.user != null) {
              authenticateUser(value.user).then((isNewUser) {
                addDataToDb(value.user);
              });
            }
          });
          break;
        case FacebookLoginStatus.cancelledByUser:
          _status = Status.Unauthenticated;
          notifyListeners();
          print('Login cancelled by the user.');
          break;
        case FacebookLoginStatus.error:
          _status = Status.Unauthenticated;
          notifyListeners();
          Func.showError(
              context,
              'Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          break;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Muser>> fetchAllUsers(User currentUser) async {
    List<Muser> userList = List<Muser>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(Muser.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Stream<QuerySnapshot> fetchFamUsers(User currentUser, String famId) =>
      firestore
          .collection(USERS_COLLECTION)
          .where("family_id", isEqualTo: famId)
          .snapshots();

  Future<void> signOut({context}) async {
    try {
      setUserState(userId: user.uid, userState: UserState.Offline);
      _auth.signOut();
      _googleSignIn.signOut();
      _status = Status.Unauthenticated;
      notifyListeners();
      return Future.delayed(Duration.zero);
    } catch (e) {
      print(e.toString());
      _status = Status.Authenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      await refreshUser();
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
