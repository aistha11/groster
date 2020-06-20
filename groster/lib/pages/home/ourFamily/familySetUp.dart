import 'package:flutter/material.dart';
import 'package:groster/pages/widgets/appbar.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/func.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class FamilySetUp extends StatefulWidget {
  @override
  _FamilySetUpState createState() => _FamilySetUpState();
}

class _FamilySetUpState extends State<FamilySetUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _familyName;
  TextEditingController _familyId;
  FocusNode textFieldFocus = FocusNode();
  @override
  void initState() {
    _familyName = TextEditingController();
    _familyId = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = Provider.of<UserRepository>(context);
    userRepository.refreshUser();
    return Scaffold(
      backgroundColor: UniversalVariables.backgroundCol,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text("Family SetUp", style: TextStyle(color: Colors.black),),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  // //Familly Name
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "*This can't be empty.";
                      return null;
                    },
                    controller: _familyName,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Family Name",
                      labelStyle: TextStyle(color: UniversalVariables.mainCol),
                      hintText: 'Enter Family Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty || val.length < 8)
                        return "*This can't be empty or can't be less than 8.";
                      return null;
                    },
                    controller: _familyId,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.person),
                      labelText: "Family Id",
                      labelStyle: TextStyle(color: UniversalVariables.mainCol),
                      hintText: 'Enter Family Id',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  //Done Button
                  const SizedBox(height: 20.0),
                  RaisedButton(
                    color: UniversalVariables.iconCol,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    textColor: Colors.white,
                    child: Text("Done"),
                    onPressed: () async {
                      Func.hideKeyboard(textFieldFocus);
                      if (_formKey.currentState.validate()) {
                        if (await userRepository.updateFamily(
                                _familyName.text, _familyId.text) ==
                            true) {
                          await userRepository.refreshUser();
                          Navigator.of(context).pop();
                        } else {
                          print("Error While Updating");
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
