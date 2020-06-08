
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:groster/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserCircle extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    UserRepository userProvider = Provider.of<UserRepository>(context);
    // var uid = userProvider.user.uid;
    // print("Uid from UserRepository in userCircle is $uid");
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/profile");
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: UniversalVariables.separatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: 
              userProvider.user.photoUrl == null ?
                     Text(
                      Utils.getInitials(userProvider.getUser.name),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: UniversalVariables.lightBlueColor,
                        fontSize: 14,
                      ),
                    )
                  : CachedImage(
                      userProvider.user.photoUrl,
                      isRound: true,
                      radius: 45,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: UniversalVariables.blackColor, width: 2),
                    color: UniversalVariables.onlineDotColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}