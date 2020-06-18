// import 'package:groster/enum/user_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groster/constants/strings.dart';
import 'package:groster/enum/user_state.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/widgets/appbar.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/func.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:groster/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final UserRepository _userRepository = UserRepository.instance();
  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = Provider.of<UserRepository>(context);
    final User user = userRepository.getUser;
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
        child: ListView(
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
                    leading: Icon(Icons.edit, color: Colors.white,),
                    title: Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () {
                      Func.toImplement(context, "Go to profile Edit Page");
                    },
                  ),
                  // ListTile(
                  //   title: Text(
                  //     "Help & Tips",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   contentPadding: EdgeInsets.only(left: 70.0),
                  //   onTap: () {
                  //     Func.toImplement(context, "Show Helps and Tips");
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text(
                  //     "Rate App",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   contentPadding: EdgeInsets.only(left: 70.0),
                  //   onTap: () {
                  //     Func.toImplement(context, "Go to playstore to rate app");
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text(
                  //     "About",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   contentPadding: EdgeInsets.only(left: 70.0),
                  //   onTap: () {
                  //     Func.toImplement(context, "Show the app details");
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(Icons.share, color: Colors.white,),
                    title: Text(
                      "Share App",
                      style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () {
                      Func.share(
                        context,
                        "Hey, I am sharing this awesome app. Please install the app from $APP_URL",
                        "Install Now",
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.signOutAlt, color: Colors.white,),
                    title: Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () async {

                       _userRepository.setUserState(
                          userId: userRepository.getUser.uid,
                          userState: UserState.Offline,
                       );
                      // Navigator.of(context).pop();
                       await _userRepository.signOut(context: context);
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
