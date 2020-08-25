import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/widgets/appbar.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/func.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:groster/utils/utilities.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final User eUser;
  final int mode;
  EditProfile({@required this.eUser, @required this.mode});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserRepository _userRepository = UserRepository.instance();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  String imageUrl;
  bool _uploading;
  bool _saving;
  @override
  void initState() {
    _firstName.text = Utils.getFirstName(widget.eUser.name);
    _lastName.text = Utils.getLastName(widget.eUser.name);
    imageUrl = widget.eUser.profilePhoto;
    _uploading = false;
    _saving = false;
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final UserRepository userRepository = Provider.of<UserRepository>(context);
    // userRepository.refreshUser();
    // final User user = userRepository.getUser;
    Future<String> uploadImageToStorage(File imageFile) async {
      StorageReference _storageReference;

      try {
        _storageReference = FirebaseStorage.instance
            .ref()
            .child('${DateTime.now().millisecondsSinceEpoch}');
        StorageUploadTask storageUploadTask =
            _storageReference.putFile(imageFile);
        var url =
            await (await storageUploadTask.onComplete).ref.getDownloadURL();
        // print(url);
        return url.toString();
      } catch (e) {
        Func.showToast(e.toString());
        return widget.eUser.profilePhoto;
      }
    }

    Future<String> pickImage({@required ImageSource source}) async {
      try{
        File selectedImage = await Utils.pickImage(source: source);
      if (selectedImage != null) {
        // Get url from the image bucket
        String url = await uploadImageToStorage(selectedImage);
        return url;
      } else {
        return widget.eUser.profilePhoto;
      }
      }catch(e){
        Func.showToast(e.toString());
        return widget.eUser.profilePhoto;
      }
    }

    return Scaffold(
      backgroundColor: UniversalVariables.backgroundCol,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        // appCol: UniversalVariables.blackColor,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //Profile
                  !_uploading ? Container(
                    child: CachedImage(
                      imageUrl,
                      isRound: true,
                      radius: 90.0,
                    ),
                  ):CircularProgressIndicator(),
                  SizedBox(
                        height: 20,
                      ),
                  //For Profile Image
                  widget.mode == 0?Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Change Profile Picture: ",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          setState(() {
                            _uploading = true;
                          });
                          await pickImage(source: ImageSource.gallery)
                              .then((value) {
                            setState(() {
                              imageUrl = value;
                              _uploading = false;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                           setState(() {
                            _uploading = true;
                          });
                          await pickImage(source: ImageSource.camera).then((value) {
                            setState(() {
                              imageUrl = value;
                              _uploading = false;
                            });
                          });
                        },
                      ),
                    ],
                  ):Container(),

                  SizedBox(
                    height: 15.0,
                  ),
                  // First Name
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "*This can't be empty.";
                      return null;
                    },
                    controller: _firstName,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "First Name",
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: Utils.getFirstName(widget.eUser.name),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //Last Name
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty) return "*This can't be empty.";
                      return null;
                    },
                    controller: _lastName,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.person),
                      labelText: "Last Name",
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: Utils.getLastName(widget.eUser.name),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  //Save Button
                  const SizedBox(height: 20.0),
                  RaisedButton(
                    color: UniversalVariables.iconCol,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    textColor: Colors.white,
                    child: !_saving ? Text("Save"):CircularProgressIndicator(),
                    onPressed: () async {
                      setState(() {
                        _saving = true;
                      });
                      Func.hideKeyboard(textFieldFocus);
                      User upUser = User(
                        uid: widget.eUser.uid,
                        name: "${_firstName.text} ${_lastName.text}",
                        profilePhoto: imageUrl,
                        username: widget.eUser.username,
                        email: widget.eUser.email,
                        familyId: widget.eUser.familyId,
                        familyName: widget.eUser.familyName
                      );
                      if (_formKey.currentState.validate()) {
                        if (await _userRepository.updateProfile(upUser) == true) {
                          // await _userRepository.refreshUser();
                          setState(() {
                            _saving = false;
                          });
                          Func.showToast("Profile Updated Successfully");
                          Navigator.of(context).pop();
                        } else {
                          Func.showToast("Error while Updating Profile");
                        }
                      }else{
                        setState(() {
                          _saving = false;
                        });
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
