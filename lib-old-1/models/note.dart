import 'database_item.dart';

class Note extends DatabaseItem{
  final String title;
  final String id;
  final DateTime createdAt;
  final String userId;
  final String quantity;
  final bool completed;

  Note({this.title, this.id, this.createdAt, this.userId, this.completed, this.quantity}):super(id);
 
  Note.fromDS(String id, Map<String,dynamic> data):
    id=id,
    title=data['title'],
    userId=data['user_id'],
    createdAt=data['created_at']?.toDate(),
    completed = data['completed'],
    quantity = data['quantity'],
    super(id);

  Map<String,dynamic> toMap() => {
    "title":title,
    "created_at": createdAt,
    "user_id": userId,
    "completed" : completed,
    "quantity" : quantity,
  };
}