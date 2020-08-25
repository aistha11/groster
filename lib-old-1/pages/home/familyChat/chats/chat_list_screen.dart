import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groster/constants/strings.dart';
import 'package:groster/constants/styles.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/contact_view.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/widgets/appbar.dart';
import 'package:groster/pages/widgets/shimmering/myShimmer.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    return Scaffold(
      backgroundColor: UniversalVariables.backgroundCol,
      appBar: CustomAppBar(
        // leading: Icon(
        //   CHAT_ICON,
        //   color: Colors.black,
        // ),
        title: Text(
          "Chat",
          style: APP_TITLE_STYLE,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "SEARCH FAMILY MEMBERS",
        backgroundColor: UniversalVariables.secondCol,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.pushNamed(context, "/search_screen");
        },
      ),
      body: Column(
        children: [
          userRepository.getUser.familyId != null
              ? GroupChatTile()
              : Container(),
          Divider(
            color: UniversalVariables.secondCol,
          ),
          Flexible(child: ChatListContainer()),
        ],
      ),
    );
  }
}

class GroupChatTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 5.0),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed("/familyGroupChat");
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: Stack(
            overflow: Overflow.clip,
            alignment: Alignment.topRight,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.only(top: 2, right: 2),
                    child: CachedImage(
                      BLANK_IMAGE,
                      isRound: true,
                      radius: 35.0,
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 2, left: 2),
                    child: CachedImage(
                      userRepository.getUser.profilePhoto,
                      isRound: true,
                      radius: 35.0,
                    ),
                  )),
            ],
          ),
        ),
        title: Text(userRepository.getUser.familyName),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  // final ChatMethods _chatMethods = ChatMethods();
  final UserRepository _userRepository = UserRepository.instance();
  @override
  Widget build(BuildContext context) {
     UserRepository userRepository = Provider.of<UserRepository>(context);
    userRepository.refreshUser();
    return StreamBuilder<QuerySnapshot>(
        // stream: _chatMethods.fetchContacts( 
        //   userId: userProvider.user.uid,
        // ),
        stream: _userRepository.fetchFamUsers(userRepository.user, userRepository.getUser.familyId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data.documents;

            if (docList.isEmpty || userRepository.getUser.familyId == null) {
              return QuietBox(
                title: "This is where you can chat with group members",
                subtitle: "Also a personal message to group member.",
                buttonText: "SEARCH",
                navRoute: "/search_screen",
                buttonText1: "SET UP GROUP",
                navRoute1: "/setUpFamily",
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: docList.length,
              itemBuilder: (context, index) {
                // Contact contact = Contact.fromMap(docList[index].data);
                User fuser = User.fromMap(docList[index].data);
                return fuser.uid != userRepository.getUser.uid ? ContactView(fuser) : Container();
              },
            );
          }

          return MyShimmer.shimCont(double.maxFinite);
        });
  }
}
