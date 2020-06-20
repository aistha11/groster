import 'package:groster/models/masterNote.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:groster/utils/func.dart';
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
  TextEditingController _quantityController;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _editMode;
  bool _processing;
  @override
  void initState() {
    super.initState();
    _processing = false;
    _editMode = widget.note != null;
    _titleController =
        TextEditingController(text: _editMode ? widget.note.title : null);
    _quantityController =
        TextEditingController(text: _editMode ? widget.note.quantity : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: UniversalVariables.mainCol,
        leading: IconButton(
            icon: Icon(Icons.clear, size: 29.0, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Add to Master List',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Title
              TextFormField(
                controller: _titleController,
                validator: (val) {
                  return val.isEmpty ? "*Required" : null;
                },
                decoration: InputDecoration(
                  labelText: "Item",
                ),
              ),
              const SizedBox(height: 10.0),
              //Quantity
              TextFormField(
                controller: _quantityController,
                validator: (val) {
                  return val.isEmpty ? "*Required" : null;
                },
                // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity",
                ),
              ),
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
                        // if (_titleController.text.isEmpty) {
                        //   _key.currentState.showSnackBar(SnackBar(
                        //     content: Text("Title is required."),
                        //   ));
                        //   setState(() {
                        //     _processing = false;
                        //   });
                        //   return;
                        // }
                        MasterNote note = MasterNote(
                          id: _editMode ? widget.note.id : null,
                          title: _titleController.text,
                          familyId: Provider.of<UserRepository>(context,
                                  listen: false)
                              .getUser
                              .familyId,
                          createdAt: DateTime.now(),
                          userId: Provider.of<UserRepository>(context,
                                  listen: false)
                              .getUser
                              .uid,
                          quantity: _quantityController.text,
                          completed: false,
                        );

                        if (_formKey.currentState.validate()) {
                          try {
                            if (_editMode) {
                              await masternotesDb.updateItem(note);
                            } else {
                              await masternotesDb.createMasterItem(note);
                            }
                            Navigator.pop(context);
                          } catch (e) {
                            setState(() {
                              _processing = false;
                            });
                            Func.showToast("Something went wrong");
                          }
                        } else {
                          setState(() {
                            _processing = false;
                          });
                        }
                      },
              )
            ],
          ),
        ),
      ),
    );
  }
}
