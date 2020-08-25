import 'dart:io';
import 'package:groster/models/groupMsg.dart';
import 'package:groster/models/user.dart';
import 'package:groster/provider/image_upload_provider.dart';
import 'package:groster/resources/chat_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groster/services/db_service.dart';

class StorageMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StorageReference _storageReference;

  //user class
  Muser user = Muser();

  Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null; 
    }
  }

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url, receiverId, senderId);
  }

  void uploadGrpImage({
    @required File image,
    @required String familyId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();
    // Get url from the image bucket
    String url = await uploadImageToStorage(image);
    // Hide loading
    imageUploadProvider.setToIdle();
    //send image as group message
    GroupMessage _grpMessage = GroupMessage(
        groupId: familyId,
        senderId: senderId,
        message: "IMAGE",
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image',
      );
    grpMsgDb.createItem(_grpMessage);
  }
}
