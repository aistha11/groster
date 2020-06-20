import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groster/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final Function(Note) onEdit;
  final Function(Note) onDelete;
  final Function(Note) onTap;
  final Function(Note) onLongPressed;
  const NoteItem(
      {Key key,
      @required this.note,
      @required this.onEdit,
      @required this.onDelete,
      this.onLongPressed,
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
          leading: Icon(FontAwesomeIcons.circle),
          title: Text(
            "${note.title} - ${note.quantity}",
            style: TextStyle(
              decoration: note.completed? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          subtitle: Text(
            note.createdAt.toString(),
            style: TextStyle(fontSize: 11.0),
          ),
          onLongPress: () => onLongPressed(note),
        ),
      ),
    );
  }
}
