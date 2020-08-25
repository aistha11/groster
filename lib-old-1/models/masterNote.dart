import 'database_item.dart';

class MasterNote extends DatabaseItem {
  final String id;
  final String title;
  final DateTime createdAt;
  final String userId;
  final String familyId;
  final String quantity;
  final bool completed;

  MasterNote({
    this.title,
    this.id,
    this.createdAt,
    this.userId,
    this.familyId,
    this.quantity,
    this.completed
  }) : super(id);

  MasterNote.fromDS(String id, Map<String, dynamic> data)
      : id = id,
        title = data['title'],
        userId = data['user_id'],
        createdAt = data['created_at']?.toDate(),
        familyId = data['family_id'],
        quantity = data['quantity'],
        completed = data['completed'],
        super(id);

  Map<String, dynamic> toMap() => {
        "title": title,
        "created_at": createdAt,
        "user_id": userId,
        "family_id": familyId,
        "quantity" : quantity,
        "completed":completed
      };
}
