import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groster/models/contact.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chatscreens/chat_screen.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/widgets/shimmering/myShimmer.dart';
import 'package:groster/resources/chat_methods.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/utilities.dart';
import 'package:provider/provider.dart';

class FamilyMembers extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();
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
          stream: _chatMethods.fetchContacts(
            userId: userRepository.user.uid,
          ),
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
                  Contact contact = Contact.fromMap(docList[index].data);

                  return FutureBuilder<User>(
                    future: userRepository.getUserDetailsById(contact.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        User user = snapshot.data;

                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return ChatScreen(
                                receiver: user,
                              );
                            }));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
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
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return MyShimmer.userCircle(50);
                    },
                  );
                },
              );
            }
            return MyShimmer.shimCont(75);
          }),
    );
  }
}
