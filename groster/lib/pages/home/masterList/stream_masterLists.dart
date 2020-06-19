import 'package:flutter/material.dart';
import 'package:groster/models/masterNote.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
import 'package:groster/pages/home/masterList/addMasterNote.dart';
import 'package:groster/pages/widgets/masterNoteItem.dart';
import 'package:groster/pages/widgets/shimmering/myShimmer.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/services/db_service.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class StreamMasterList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    userRepository.refreshUser();
    final String fuid = userRepository.getUser.familyId;
    return fuid == null
        ? Container(
            child: QuietBox(
                title: "Set Up Your Family Profile",
                subtitle: "After this you can add the family list",
                buttonText: "SetUp Now",
                navRoute: "/setUpFamily"),
          )
        : StreamBuilder(
            stream: masternotesDb.streamMasterList(fuid),
            builder: (BuildContext context,
                AsyncSnapshot<List<MasterNote>> snapshot) {
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
                return ListView.separated(
                  separatorBuilder: (_, i) {
                    if (i.isEven)
                      return Divider(
                        color: UniversalVariables.secondCol,
                        thickness: 1,
                      );
                    else
                      return Divider(
                        color: UniversalVariables.mainCol,
                        thickness: 1,
                      );
                  },
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
                    );
                  },
                );
              }

              return ListView(
                children: [
                  MyShimmer.shimMasterTile(),
                  MyShimmer.shimMasterTile(),
                ],
              );
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
