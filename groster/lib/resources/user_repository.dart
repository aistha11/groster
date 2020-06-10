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
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;
  User _fuser;
  Status _status = Status.Uninitialized;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  static final Firestore _firestore = Firestore.instance;
  static final Firestore firestore = Firestore.instance;

  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  User get getUser => _fuser;

  Future<FirebaseUser> getCurrentUser() async {
    try {
      FirebaseUser currentUser;
      currentUser = await _auth.currentUser();
      return currentUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> getUserDetails() async {
    try {
      FirebaseUser currentUser = await getCurrentUser();

      DocumentSnapshot documentSnapshot =
          await _userCollection.document(currentUser.uid).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print("Error while getiing user detail");
      print(e);
      return _fuser;
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

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.document(userId).updateData({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.document(uid).snapshots();

  Future<void> refreshUser() async {
    User user = await getUserDetails();
    _fuser = user;
    notifyListeners();
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

  Future<void> addDataToFdb(FirebaseUser newUser, String name) async {
    String username = Utils.getUsername(newUser.email);

    User user = User(
        uid: newUser.uid,
        email: newUser.email,
        name: name,
        profilePhoto: newUser.photoUrl,
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

  Future<bool> signUp(BuildContext context,String email, String password, String name) async {
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

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      await _auth.signInWithCredential(credential).then((value){
        if(value.user != null){
             authenticateUser(value.user).then((isNewUser){
               addDataToDb(value.user);
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
    try{
      _status = Status.Authenticating;
      notifyListeners();
      final FacebookLoginResult result =
        await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
         await _auth.signInWithCredential(credential).then((value){
           if(value.user != null){
             authenticateUser(value.user).then((isNewUser){
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
        Func.showError(context, 'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
    }catch(e){
      print(e.toString());
    }
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

  Future<void> signOut() async {
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
