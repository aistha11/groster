import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groster/models/contact.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/contact_view.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
// import 'package:groster/provider/user_provider.dart';
import 'package:groster/resources/chat_methods.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: UniversalVariables.scfBgColor,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        body: ChatListContainer(),
      );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    final UserRepository userProvider = Provider.of<UserRepository>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.user.uid,
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
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
