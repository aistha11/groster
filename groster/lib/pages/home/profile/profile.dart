import 'package:groster/enum/user_state.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/widgets/appbar.dart';
// import 'package:groster/pages/wrapper.dart';
// import 'package:groster/provider/user_provider.dart';
import 'package:groster/resources/auth_methods.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:groster/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    final UserRepository userProvider = Provider.of<UserRepository>(context);
    final User user = userProvider.getUser;
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        appCol: UniversalVariables.blackColor,
        title: Text("Profile"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  user.profilePhoto != null
                      ? CachedImage(
                          user.profilePhoto,
                          isRound: true,
                          radius: 80,
                        )
                      : Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: UniversalVariables.separatorColor,
                          ),
                          child: Center(
                            child: Text(
                              Utils.getInitials(user.name),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: UniversalVariables.lightBlueColor,
                                fontSize: 20,
                              ),
                            ),
                          )),
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  ListTile(
                    title: Text(
                      "Settings",
                      style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      "Help & Tips",
                      style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      "About",
                      style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () async {
                      final bool isLoggedOut = await authMethods.signOut();
                      if (isLoggedOut) {
                        // set userState to offline as the user logs out'
                        authMethods.setUserState(
                          userId: userProvider.getUser.uid,
                          userState: UserState.Offline,
                        );
                        Navigator.pop(context);

                        // move the user to login screen
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Wrapper()),
                        //   (Route<dynamic> route) => false,
                        // );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
