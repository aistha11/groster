import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groster/models/database_item.dart';

class GroupMessage extends DatabaseItem{
  final String id;
  final String senderId;
  final String groupId;
  final String type;
  final String message;
  final Timestamp timestamp;
  final String photoUrl;

  GroupMessage({
    this.id,
    this.senderId,
    this.groupId,
    this.type,
    this.message,
    this.timestamp,
    this.photoUrl,
  }):super(id);

  //Will be only called when you wish to send an image
  // named constructor
  GroupMessage.imageMessage({
    this.id,
    this.senderId,
    this.groupId,
    this.message,
    this.type,
    this.timestamp,
    this.photoUrl,
  }):super(id);

  // Map toMap() {
  //   var map = Map<String, dynamic>();
  //   map['id'] = this.id; 
  //   map['senderId'] = this.senderId;
  //   map['groupId'] = this.groupId;
  //   map['type'] = this.type;
  //   map['message'] = this.message;
  //   map['timestamp'] = this.timestamp;
  //   return map;
  // }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['message'] = this.message;
    map['senderId'] = this.senderId;
    map['groupId'] = this.groupId;
    map['type'] = this.type;
    map['timestamp'] = this.timestamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  // named constructor
  // GroupMessage.fromMap(Map<String, dynamic> map) {
  //   this.senderId = map['senderId'];
  //   this.groupId = map['groupId'];
  //   this.type = map['type'];
  //   this.message = map['message'];
  //   this.timestamp = map['timestamp'];
  //   this.photoUrl = map['photoUrl'];
  // }
  GroupMessage.fromDS(String id, Map<String,dynamic> data):
    id=id,
    message=data['message'],
    groupId=data["groupId"],
    photoUrl=data["photoUrl"],
    senderId=data["senderId"],
    timestamp=data["timestamp"],
    type=data["type"],
    super(id);

  Map<String,dynamic> toMap() => {
    "message":message,
    "groupId": groupId,
    "photoUrl": photoUrl,
    "senderId":senderId,
    "timestamp":timestamp,
    "type":type
  };
}
