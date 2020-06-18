import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groster/constants/strings.dart';
import 'package:groster/enum/view_state.dart';
import 'package:groster/models/groupMsg.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/widgets/appbar.dart';
import 'package:groster/provider/image_upload_provider.dart';
import 'package:groster/resources/storage_methods.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/services/db_service.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:groster/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FamilyGroupChat extends StatefulWidget {
  @override
  _FamilyGroupChatState createState() => _FamilyGroupChatState();
}

class _FamilyGroupChatState extends State<FamilyGroupChat> {
  ImageUploadProvider _imageUploadProvider;
  UserRepository _userRepository;
  final StorageMethods _storageMethods = StorageMethods();
  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  ScrollController _listScrollController = ScrollController();
  User sender;
  String _currentUserId;
  bool isWriting = false;
  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();
  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
     _userRepository = Provider.of<UserRepository>(context);
    _userRepository.refreshUser();
    sender = _userRepository.getUser;
    _currentUserId = _userRepository.getUser.uid;
    return Scaffold(
      backgroundColor: UniversalVariables.scfBgColor,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.home,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: Stack(
                overflow: Overflow.clip,
                alignment: Alignment.topRight,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: CachedImage(
                        BLANK_IMAGE,
                        isRound: true,
                        radius: 30.0,
                      )),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: CachedImage(
                        sender.profilePhoto,
                        isRound: true,
                        radius: 30.0,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                sender.familyId,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 15),
                  child: CircularProgressIndicator(),
                )
              : Container(),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: grpMsgDb.streamGroupMessages(sender.familyId),
      builder: (context, AsyncSnapshot<List<GroupMessage>> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.all(10),
          controller: _listScrollController,
          reverse: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(GroupMessage chatItem) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        alignment: chatItem.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: chatItem.senderId == _currentUserId
            ? senderLayout(chatItem)
            : receiverLayout(chatItem),
      ),
    );
  }

  Widget senderLayout(GroupMessage message) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 1),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: message.type != MESSAGE_TYPE_IMAGE
            ? EdgeInsets.all(10)
            : EdgeInsets.all(0),
        child: getMessage(message),
      ),
    );
  }
  getMessage(GroupMessage message) {
    return message.type != MESSAGE_TYPE_IMAGE
        ? Text(
            message.message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        : message.photoUrl != null
            ? CachedImage(
                message.photoUrl,
                height: 250,
                width: 250,
                radius: 10,
              )
            : Text("Url was null");
  }
  Widget receiverLayout(GroupMessage message) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 1),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: message.type != MESSAGE_TYPE_IMAGE
            ? EdgeInsets.all(10)
            : EdgeInsets.all(0),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    sendMessage() {
      var text = textFieldController.text;
      GroupMessage _grpMessage = GroupMessage(
        groupId: sender.familyId,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: 'text',
      );
      setState(() {
        isWriting = false;
      });
      textFieldController.text = "";
      grpMsgDb.createItem(_grpMessage);
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          //Show an arrow to show add image option
          isWriting
              ? GestureDetector(
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: UniversalVariables.appBarColor,
                    size: 30.0,
                  ),
                  onTap: () {
                    setState(() {
                      isWriting = false;
                    });
                  },
                )
              : Container(),
          //Add Image From gallery
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(Icons.image),
                  onTap: () => pickImage(source: ImageSource.gallery),
                ),
          SizedBox(
            width: 5,
          ),
          //Add Image From Camera
          isWriting
              ? Container()
              : GestureDetector(
                  child: Icon(Icons.camera_alt),
                  onTap: () => pickImage(source: ImageSource.camera),
                ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                  ),
                ),
              ],
            ),
          ),

          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 20,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    if (selectedImage != null)
      _storageMethods.uploadGrpImage(
          image: selectedImage,
          familyId: sender.familyId,
          senderId: _currentUserId,
          imageUploadProvider: _imageUploadProvider);
  }
}

