import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chatscreens/chat_screen.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/widgets/shimmering/myShimmer.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/utilities.dart';
import 'package:provider/provider.dart';

class FamilyMembers extends StatelessWidget {
  // final ChatMethods _chatMethods = ChatMethods();

  final UserRepository _userRepository = UserRepository.instance();

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    userRepository.refreshUser();
    return Container(
      // margin: EdgeInsets.only(left: 25.0),
      width: double.infinity,
      height: 85.0,
      // color: Colors.grey,
      child: StreamBuilder<QuerySnapshot>(
          stream: _userRepository.fetchFamUsers(
              userRepository.user, userRepository.getUser.familyId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return Container();
              }
              return ListView.separated(
                separatorBuilder: (_, i) {
                  return SizedBox(
                    width: 5.0,
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  User fuser = User.fromMap(docList[index].data);
                  // return fuser.uid != userRepository.getUser.uid?FamilyUsers(fuser,index):Container();
                  return FamilyUsers(fuser, index);
                },
              );
            }
            return MyShimmer.shimCont(75);
          }),
    );
  }
}

class FamilyUsers extends StatelessWidget {
  final User fuser;
  final int index;
  FamilyUsers(this.fuser, this.index);
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    userRepository.refreshUser();
    return FutureBuilder<User>(
      future: userRepository.getUserDetailsById(fuser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ChatScreen(
                  receiver: user,
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Column(
                children: [
                  CachedImage(
                    user.profilePhoto,
                    radius: 50,
                    isRound: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      Utils.getFirstName(user.name),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return MyShimmer.shimFamUserTile();
      },
    );
  }
}
