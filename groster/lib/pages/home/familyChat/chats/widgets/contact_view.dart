
import 'package:flutter/material.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/online_dot_indicator.dart';
import 'package:groster/pages/home/familyChat/chatscreens/chat_screen.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/widgets/custom_tile.dart';
import 'package:groster/pages/widgets/shimmering/myShimmer.dart';
import 'package:groster/resources/chat_methods.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:provider/provider.dart';

import 'last_message_container.dart';

class ContactView extends StatelessWidget {
  final Muser cUser;
  final UserRepository _authMethods = UserRepository.instance();

  ContactView(this.cUser);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Muser>(
      future: _authMethods.getUserDetailsById(cUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Muser user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return MyShimmer.shimChatTile();
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final Muser contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    final UserRepository userProvider = Provider.of<UserRepository>(context);

    return CustomTile(
      mini: true,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Text(
        (contact != null ? contact.name : null) != null ? contact.name : "..",
        style:
            TextStyle(color: UniversalVariables.titCol, fontFamily: "Arial", fontSize: 15),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 40,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
