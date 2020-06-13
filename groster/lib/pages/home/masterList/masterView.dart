// import 'package:flutter/material.dart';
// import 'package:groster/models/contact.dart';
// import 'package:groster/models/masterNote.dart';
// import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
// import 'package:groster/pages/home/masterList/addMasterNote.dart';
// import 'package:groster/pages/widgets/masterNoteItem.dart';
// // import 'package:groster/resources/user_repository.dart';
// import 'package:groster/services/db_service.dart';
// // import 'package:provider/provider.dart';

// class MasterView extends StatelessWidget {
//   final Contact contact;
//   // final UserRepository _authMethods = UserRepository.instance();

//   MasterView({this.contact});

//   @override
//   Widget build(BuildContext context) {
//     // UserRepository userProvider = Provider.of<UserRepository>(context);
//     return Container(
//       child: StreamBuilder(
//           stream: masternotesDb.streamMasterList(contact.uid),
//           builder: (BuildContext context, AsyncSnapshot<List<MasterNote>> snapshot) {
//             if (snapshot.hasError)
//               return Container(
//                 child: Center(
//                   child: Text("There was an error"),
//                 ),
//               );

//             if (snapshot.hasData) {
//               var docList = snapshot.data;

//               if (docList.isEmpty) {
//                 return QuietBox(
//                   title: "This is where all your master list are shown",
//                   subtitle:
//                       "Start adding your list which can be viewed by your family too",
//                   buttonText: "Add To Master List",
//                   navRoute: "/addMasterNote",
//                 );
//               }
//               return Container(
//                 child: ListView.builder(
//                   itemCount: snapshot.data.length,
//                   itemBuilder: (context, index) {
//                     return MasterNoteItem(
//                       note: snapshot.data[index],
//                       onEdit: (note) {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => AddMasterNote(
//                                 note: note,
//                               ),
//                             ));
//                       },
//                       onDelete: (note) async {
//                         if (await _confirmDelete(context)) {
//                           masternotesDb.removeItem(note.id);
//                         }
//                       },
//                       //
//                       onTap: (note) {
//                         showDialog(
//                           context: context,
//                           child: AlertDialog(
//                             title: Text(note.title),
//                             content: Container(
//                               height: 200.0,
//                               child: Column(
//                                 children: [
//                                   Text('Id : ${note.id}'),
//                                   // Text('Family ID: ${note.familyId}'),
//                                   Text('Created At : ${note.createdAt}'),
//                                   Text('User Id : ${note.userId}'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               );
//             }

//             return Center(child: CircularProgressIndicator());
//           },
//         ),
//     );
//   }

//   Future<bool> _confirmDelete(BuildContext context) async {
//     return showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Text("Confirm Delete"),
//               content: Text("Are you sure you want to delete?"),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text("No"),
//                   onPressed: () => Navigator.pop(context, false),
//                 ),
//                 FlatButton(
//                   child: Text("Yes"),
//                   onPressed: () => Navigator.pop(context, true),
//                 ),
//               ],
//             ));
//   }
// }
