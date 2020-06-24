import 'package:groster/constants/styles.dart';
import 'package:groster/models/note.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
import 'package:groster/pages/home/personalList/addPersonalNote.dart';
import 'package:groster/pages/widgets/appbar.dart';
import 'package:groster/pages/widgets/notesItem.dart';
import 'package:groster/pages/widgets/shimmering/myShimmer.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:groster/utils/func.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class PersonalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserRepository userProvider = Provider.of<UserRepository>(context);
    userProvider.refreshUser();
    var uid = userProvider.user.uid;
    return Scaffold(
      appBar: CustomAppBar(
        // leading: Icon(PERSONAL_ICON, color: Colors.black),
        title: Text(
          "Personal List",
          style: APP_TITLE_STYLE,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: personalnotesDb.streamList(uid),
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
                title: "This is where all your personal list are shown",
                subtitle: "Start adding your own list",
                buttonText: "ADD TO PERSONAL LIST",
                navRoute: "/addPersonalNote",
              );
            }
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (_, i) {
                return i.isEven
                    ? Divider(
                        color: UniversalVariables.mainCol,
                        // thickness: 1,
                        height: 1.0,
                      )
                    : Divider(
                        color: UniversalVariables.secondCol,
                        // thickness: 1,
                        height: 1.0,
                      );
              },
              itemBuilder: (context, index) {
                return NoteItem(
                  index: index,
                  note: snapshot.data[index],
                  onEdit: (note) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddPersonalNote(
                            note: note,
                          ),
                        ));
                  },
                  onDelete: (note) async {
                    if (await Func.confirmBox(context, "Confirm Delete",
                        "Do you really want to delete?")) {
                      personalnotesDb.removeItem(note.id);
                    }
                  },
                  onLongPressed: (note) async {
                    Note upNote = Note(
                      id: note.id,
                      userId: note.userId,
                      createdAt: note.createdAt,
                      completed: !note.completed,
                      quantity: note.quantity,
                      title: note.title,
                    );
                    await personalnotesDb.updateItem(upNote);
                  },
                );
              },
            );
          }

          return MyShimmer.shimCont(double.infinity);
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "ADD TO PERSONAL LIST",
        backgroundColor: UniversalVariables.secondCol,
        child: Icon(
          Icons.add,
          color: UniversalVariables.backgroundCol,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/addPersonalNote");
        },
      ),
    );
  }
}
