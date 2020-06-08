import 'package:flutter/material.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/home.dart';
import 'package:groster/pages/widgets/splash.dart';
import 'package:groster/resources/auth_methods.dart';

class HomePage extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authMethods.getUserDetails(),
      // initialData: User(
      //   uid: "qeretrqtrtqeadfasdf",
      //   email: "noemail@gmail.com",
      //   name: "No Name",
      //   profilePhoto: "https://fertilitynetworkuk.org/wp-content/uploads/2017/01/Facebook-no-profile-picture-icon-620x389.jpg",
      //   state: 0,
      //   status: null,
      //   username: "@username"
      // ),
      builder: (context, AsyncSnapshot<User> snapshot) {
        // if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData)
            return Home();
          else
            return Splash();
        // }else{
          // return Splash();
        // }
      },
    );
  }
}
