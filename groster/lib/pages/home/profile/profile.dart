import 'package:groster/constants/icons.dart';
import 'package:groster/constants/strings.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/home/profile/editProfile.dart';
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
    userRepository.refreshUser();
    final User user = userRepository.getUser;
    return Scaffold(
      backgroundColor: UniversalVariables.backgroundCol,
      body: Container(
        margin: EdgeInsets.only(top: 25),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  user.profilePhoto != null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: UniversalVariables.mainCol,
                          ),
                          child: Stack(
                            overflow: Overflow.clip,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: CachedImage(
                                  user.profilePhoto,
                                  isRound: true,
                                  radius: 100.0 - 2.0,
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    // padding: EdgeInsets.only(left: 30.0),
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: UniversalVariables.iconProfileCol,
                                    ),
                                    child: IconButton(
                                        icon: Icon(Icons.edit),
                                        tooltip: "CHANGE PROFILE",
                                        iconSize: 20,
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (_) {
                                            return EditProfile(
                                              eUser: user,
                                              mode: 0,
                                            );
                                          }));
                                        }),
                                  )),
                            ],
                          ),
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
                                // color: UniversalVariables.lightBlueColor,
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
                          // color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          // color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  ListTile(
                    leading: IconButton(
                      tooltip: "EDIT PROFILE",
                      icon: Icon(
                        EDIT_ICON,
                        // color: UniversalVariables.iconCol,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return EditProfile(
                            eUser: user,
                            mode: 1,
                          );
                        }));
                      },
                    ),
                    title: Text(
                      "Edit Profile",
                      style: TextStyle(
                          // color: Colors.white,
                          ),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return EditProfile(
                          eUser: user,
                          mode: 1,
                        );
                      }));
                    },
                  ),
                  ListTile(
                    leading: IconButton(
                      tooltip: "Tell a friend",
                      icon: Icon(
                        SHARE_ICON,
                        // color: UniversalVariables.iconCol,
                      ),
                      onPressed: () {
                        Func.share(
                          context,
                          "Hey! I would like to share Groster, A Grocery List App. $APP_URL",
                          "Install App",
                        );
                      },
                    ),
                    title: Text(
                      "Tell a friend",
                      // style: TextStyle(
                      //   color: Colors.white,
                      // ),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () {
                      Func.share(
                        context,
                        "Hey! I would like to share Groster, A Grocery List App. $APP_URL",
                        "Install App",
                      );
                    },
                  ),
                  ListTile(
                    leading: IconButton(
                      tooltip: "LOG OUT",
                      icon: Icon(
                        LOGOUT_ICON,
                        // color: UniversalVariables.iconCol,
                      ),
                      onPressed: () async {
                        if (await Func.confirmBox(context, "Log Out",
                            "Do you really want to log out?")) {
                          await _userRepository.signOut(context: context);
                        }
                      },
                    ),
                    title: Text(
                      "Log Out",
                      // style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () async {
                      if (await Func.confirmBox(context, "Log Out",
                          "Do you really want to log out?")) {
                        await _userRepository.signOut(context: context);
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
