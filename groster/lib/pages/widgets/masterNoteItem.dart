import 'package:groster/models/masterNote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
          onTap: () => onTap(note),
          title: Text(note.title),
        ),
      ),
    );
  }
}
