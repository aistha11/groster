import 'database_item.dart';

class Note extends DatabaseItem{
  final String title;
  final String id;
  final DateTime createdAt;
  final String userId;

  Note({this.title, this.id, this.createdAt, this.userId}):super(id);

  Note.fromDS(String id, Map<String,dynamic> data):
    id=id,
    title=data['title'],
    userId=data['user_id'],
    createdAt=data['created_at']?.toDate(),
    super(id);

  Map<String,dynamic> toMap() => {
    "title":title,
    "created_at": createdAt,
    "user_id": userId,
  };
}