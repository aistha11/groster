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
  // TextEditingController _familyName;
  TextEditingController _familyId;
  FocusNode textFieldFocus = FocusNode();
  @override
  void initState() {
    // _familyName = TextEditingController();
    _familyId = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final UserRepository userRepository = Provider.of<UserRepository>(context);
      userRepository.refreshUser();
      // final User user = userRepository.getUser;

    // Future<String> uploadImageToStorage(File imageFile) async {
    //   StorageReference _storageReference;

    //   try {
    //     _storageReference = FirebaseStorage.instance
    //         .ref()
    //         .child('${DateTime.now().millisecondsSinceEpoch}');
    //     StorageUploadTask storageUploadTask =
    //         _storageReference.putFile(imageFile);
    //     var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    //     // print(url);
    //     return url;
    //   } catch (e) {
    //     return null;
    //   }
    // }

    // void pickImage({@required ImageSource source}) async {
    //   File selectedImage = await Utils.pickImage(source: source);
    //   if (selectedImage != null){
    //     // Get url from the image bucket
    //   String url = await uploadImageToStorage(selectedImage);
    //   }
    // }

    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        appCol: UniversalVariables.blackColor,
        title: Text("Family SetUp"),
      ),
      body: Center(
        child: Container(
                margin: EdgeInsets.all(30.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Text("Add Image"),
                        // GestureDetector(
                        //   child: Icon(Icons.image),
                        //   onTap: () => pickImage(source: ImageSource.gallery),
                        // ),
                        // GestureDetector(
                        //   child: Icon(Icons.camera_alt),
                        //   onTap: () => pickImage(source: ImageSource.camera),
                        // ),
                        // //Familly Name
                        // TextFormField(
                        //   validator: (val) {
                        //     if (val.isEmpty) return "*This can't be empty.";
                        //     return null;
                        //   },
                        //   controller: _familyName,
                        //   textInputAction: TextInputAction.next,
                        //   decoration: InputDecoration(
                        //     // prefixIcon: Icon(Icons.person),
                        //     labelText: "Family Name",
                        //     hintText: 'Family Name',
                        //     filled: true,
                        //     fillColor: Colors.white,
                        //   ),
                        // ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val.isEmpty) return "*This can't be empty.";
                            return null;
                          },
                          controller: _familyId,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.person),
                            labelText: "Family Id",
                            hintText: 'Family Id',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        //Done Button
                        const SizedBox(height: 20.0),
                        RaisedButton(
                          color: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40))),
                          textColor: Colors.white,
                          child: Text("Done"),
                          onPressed: () async {
                            Func.hideKeyboard(textFieldFocus);
                            if (_formKey.currentState.validate()) {
                              if(await userRepository.updateFamily(_familyId.text) == true){
                                await userRepository.refreshUser();
                                Navigator.of(context).pop();
                              }
                              else{
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