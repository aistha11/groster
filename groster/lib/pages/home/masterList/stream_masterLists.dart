import 'package:flutter/material.dart';
import 'package:groster/models/note.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
import 'package:groster/pages/home/masterList/addMasterNote.dart';
import 'package:groster/pages/widgets/notesItem.dart';
// import 'package:groster/provider/user_provider.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/services/db_service.dart';
import 'package:provider/provider.dart';

class StreamMasterList extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    // UserProvider userProvider = Provider.of<UserProvider>(context);
    // var uid = userProvider.getUser.uid;
    //   print("Uid from Provider is $uid");
    UserRepository userProvider = Provider.of<UserRepository>(context);
    var uid = userProvider.user.uid;
    print("Uid from UserRepository is $uid");
    return StreamBuilder(
        stream: masternotesDb.streamList(uid),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
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
                return NoteItem(
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