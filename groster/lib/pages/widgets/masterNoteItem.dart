import 'package:groster/models/masterNote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/widgets/shimmering/myShimmer.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:provider/provider.dart';

class MasterNoteItem extends StatelessWidget {
  final MasterNote note;
  final Function(MasterNote) onEdit;
  final Function(MasterNote) onDelete;
  final Function(MasterNote) onTap;
  const MasterNoteItem(
      {Key key,
      @required this.note,
      @required this.onEdit,
      @required this.onDelete,
      this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    userRepository.refreshUser();
    bool isMyNote(){
      return userRepository.getUser.uid == note.userId ? true : false;
    }
    return FutureBuilder(
      future: userRepository.getUserDetailsById(note.userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              enabled: isMyNote(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.blue,
                  icon: Icons.edit,
                  onTap: () => onEdit(note),
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () => onDelete(note),
                ),
              ],
              child: ListTile(
                leading: Container(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                  child: CachedImage(
                    user.profilePhoto,
                    radius: 35,
                    isRound: true,
                  ),
                ),
                onTap: () => onTap(note),
                title: Text(note.title),
              ),
            ),
          );
        }
        return MyShimmer.shimMasterTile();
      },
    );
  }
}
