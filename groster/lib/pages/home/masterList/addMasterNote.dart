import 'package:groster/models/masterNote.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class AddMasterNote extends StatefulWidget {
  final MasterNote note;

  const AddMasterNote({Key key, this.note}) : super(key: key);
  @override
  _AddMasterNoteState createState() => _AddMasterNoteState();
}

class _AddMasterNoteState extends State<AddMasterNote> {
  TextEditingController _titleController;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _editMode;
  bool _processing;
  @override
  void initState() {
    super.initState();
    _processing = false;
    _editMode = widget.note != null;
    _titleController =
        TextEditingController(text: _editMode ? widget.note.title : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: UniversalVariables.mainCol,
        leading: IconButton(
            icon: Icon(Icons.clear, size: 29.0, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Add to Master List'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
            ),
            const SizedBox(height: 10.0),
            const SizedBox(height: 10.0),
            RaisedButton(
              color: UniversalVariables.iconCol,
              child: _processing ? CircularProgressIndicator() : Text("Save"),
              onPressed: _processing
                  ? null
                  : () async {
                      setState(() {
                        _processing = true;
                      });
                      if (_titleController.text.isEmpty) {
                        _key.currentState.showSnackBar(SnackBar(
                          content: Text("Title is required."),
                        ));
                        return;
                      }
                      MasterNote note = MasterNote(
                        id: _editMode ? widget.note.id : null,
                        title: _titleController.text,
                        familyId: Provider.of<UserRepository>(context,listen: false).getUser.familyId,
                        createdAt: DateTime.now(),
                        userId:
                            Provider.of<UserRepository>(context, listen: false)
                                .getUser
                                .uid,
                      );
                      if (_editMode) {
                        await masternotesDb.updateItem(note);
                      } else {
                        await masternotesDb.createMasterItem(note);
                      }
                      Navigator.pop(context);
                    },
            )
          ],
        ),
      ),
    );
  }
}
