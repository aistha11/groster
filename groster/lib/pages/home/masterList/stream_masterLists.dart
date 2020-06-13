import 'package:flutter/material.dart';
import 'package:groster/models/masterNote.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
import 'package:groster/pages/home/masterList/addMasterNote.dart';
import 'package:groster/pages/widgets/masterNoteItem.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/services/db_service.dart';
import 'package:provider/provider.dart';

class StreamMasterList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserRepository userProvider = Provider.of<UserRepository>(context);
    var uid = userProvider.user.uid;
    print("Uid from UserRepository is $uid");
    return StreamBuilder(
        stream: masternotesDb.streamMasterList(uid),
        builder: (BuildContext context, AsyncSnapshot<List<MasterNote>> snapshot) {
          if (snapshot.hasError)
            return Container(
              child: Center(
                child: Text("There was an error"),
              ),
            );

          if (snapshot.hasData) {
            var docList = snapshot.data;

            if (docList.isEmpty) {
              return QuietBox(
                title: "This is where all your master list are shown",
                subtitle:
                    "Start adding your list which can be viewed by your family too",
                buttonText: "Add To Master List",
                navRoute: "/addMasterNote",
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return MasterNoteItem(
                  note: snapshot.data[index],
                  onEdit: (note) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddMasterNote(
                            note: note,
                          ),
                        ));
                  },
                  onDelete: (note) async {
                    if (await _confirmDelete(context)) {
                      masternotesDb.removeItem(note.id);
                    }
                  },
                  //
                  onTap: (note) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text(note.title),
                        content: Container(
                          height: 200.0,
                          child: Column(
                            children: [
                              Text('Id : ${note.id}'),
                              // Text('Family ID: ${note.familyId}'),
                              Text('Created At : ${note.createdAt}'),
                              Text('User Id : ${note.userId}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Confirm Delete"),
              content: Text("Are you sure you want to delete?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:groster/models/contact.dart';
// import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
// import 'package:groster/pages/home/masterList/masterView.dart';
// import 'package:groster/resources/chat_methods.dart';
// import 'package:groster/resources/user_repository.dart';
// import 'package:provider/provider.dart';

// class StreamMasterList extends StatelessWidget {
//   final ChatMethods _chatMethods = ChatMethods();

//   @override
//   Widget build(BuildContext context) {
//     UserRepository userProvider = Provider.of<UserRepository>(context);
//     var uid = userProvider.user.uid;
//     print("Uid from UserRepository is $uid");

//     Stream<QuerySnapshot> getStremMasterList() {
//       Stream<QuerySnapshot> results;
//       Stream<QuerySnapshot> contacts = _chatMethods.fetchContacts(
//         userId: userProvider.getUser.uid,
//       );
//       //       var docList = contacts.;
//       //       Contact contact = Contact.fromMap(docList[0].data);
//       // Stream<List<MasterNote>> msList = masternotesDb.streamMasterList(contact.uid);
//       results = contacts;
//       return results;
//     }

//     return Container(
//       child: StreamBuilder<QuerySnapshot>(
//           stream: getStremMasterList(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               var docList = snapshot.data.documents;

//               if (docList.isEmpty) {
//                 return QuietBox(
//                   title: "This is where all your family members are listed",
//                   subtitle: "Search for your family members to chat with them",
//                   buttonText: "START SEARCHING",
//                   navRoute: "/search_screen",
//                 );
//               }
//               return Container(
//                 child: ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: docList.length,
//                   itemBuilder: (context, index) {
//                     Contact contact = Contact.fromMap(docList[index].data);
//                     return MasterView(
//                       contact: contact,
//                     );
//                     // return ListTile(
//                     //   title: Text("${contact.uid}"),
//                     // );
//                   },
//                 ),
//               );
//             }

//             return Center(child: CircularProgressIndicator());
//           }),
//     );
//   }

//   // Future<bool> _confirmDelete(BuildContext context) async {
//   //   return showDialog(
//   //       context: context,
//   //       builder: (context) => AlertDialog(
//   //             title: Text("Confirm Delete"),
//   //             content: Text("Are you sure you want to delete?"),
//   //             actions: <Widget>[
//   //               FlatButton(
//   //                 child: Text("No"),
//   //                 onPressed: () => Navigator.pop(context, false),
//   //               ),
//   //               FlatButton(
//   //                 child: Text("Yes"),
//   //                 onPressed: () => Navigator.pop(context, true),
//   //               ),
//   //             ],
//   //           ));
//   // }

// }
