import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groster/models/contact.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
import 'package:groster/pages/home/familyChat/chatscreens/chat_screen.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/resources/chat_methods.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:provider/provider.dart';

class OurFamily extends StatefulWidget {
  @override
  _OurFamilyState createState() => _OurFamilyState();
}

class _OurFamilyState extends State<OurFamily> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Our Family"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 2.0,
          ),
          ScrollUsers(),
          SizedBox(
            height: 130.0,
          ),
          FamilyBody(),
        ],
      ),
    );
  }
}

class ScrollUsers extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();
  final UserRepository _authMethods = UserRepository.instance();
  @override
  Widget build(BuildContext context) {
    final UserRepository userProvider = Provider.of<UserRepository>(context);
    return Container(
      height: 70.0,
      color: Colors.grey,
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox(
                  title: "This is where all your family members are listed",
                  subtitle: "Search for your family members to chat with them",
                  buttonText: "START SEARCHING",
                  navRoute: "/search_screen",
                );
              }
              return ListView.separated(
                separatorBuilder: (_,i){
                  return SizedBox(
                    width: 5.0,
                  );
                },
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return FutureBuilder<User>(
                    future: _authMethods.getUserDetailsById(contact.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        User user = snapshot.data;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    receiver: user,
                                  ),
                                ));
                          },
                          child: CachedImage(
                            user.profilePhoto,
                            radius: 50,
                            isRound: true,
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class FamilyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey,
      margin: EdgeInsets.only(left: 45.0),
      child: Center(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Family Settings"),
              onTap: (){
                //Go to settings
              },
            ),
            ListTile(
              leading: Icon(Icons.trip_origin),
              title: Text("Plan a Trip"),
              onTap: (){
                //Plan a trip
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Share with Friends"),
              onTap: (){
                //Share
              },
            ),
          ],
        ),
      ),
    );
  }
}