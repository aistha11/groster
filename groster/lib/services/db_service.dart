import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groster/constants/strings.dart';
import 'package:groster/models/database_item.dart';
import 'package:groster/models/groupMsg.dart';
import 'package:groster/models/masterNote.dart';
import 'package:groster/models/note.dart';

class DatabaseService<T extends DatabaseItem> {
  final String collection;
  final Firestore _db = Firestore.instance;
  final T Function(String, Map<String, dynamic>) fromDS;
  final Map<String, dynamic> Function(T) toMap;
  DatabaseService(this.collection, {this.fromDS, this.toMap});

  Future<T> getSingle(String id) async {
    var snap = await _db.collection(collection).document(id).get();
    if (!snap.exists) return null;
    return fromDS(snap.documentID, snap.data);
  }

  Stream<T> streamSingle(String id) {
    return _db
        .collection(collection)
        .document(id)
        .snapshots()
        .map((snap) => fromDS(snap.documentID, snap.data));
  }

  Stream<List<T>> streamList(String uid) {
    var ref = _db.collection(collection).where("user_id", isEqualTo: uid).orderBy("created_at",descending: true);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Stream<List<T>> streamMasterList(String fuid) {
    var ref = _db.collection(collection).where("family_id", isEqualTo: fuid).orderBy("created_at",descending: true);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Stream<List<T>> streamGroupMessages(String guid) {
    var ref = _db.collection(collection).where("groupId", isEqualTo: guid).orderBy("timestamp",descending: true);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Future<List<T>> getQueryList({List<QueryArgs> args = const []}) async {
    CollectionReference collref = _db.collection(collection);
    Query ref;
    for (QueryArgs arg in args) {
      if (ref == null)
        ref = collref.where(arg.key, isEqualTo: arg.value);
      else
        ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    QuerySnapshot query;
    if (ref != null)
      query = await ref.getDocuments();
    else
      query = await collref.getDocuments();

    return query.documents
        .map((doc) => fromDS(doc.documentID, doc.data))
        .toList();
  }

  Stream<List<T>> streamQueryList({List<QueryArgs> args = const []}) {
    CollectionReference collref = _db.collection(collection);
    Query ref;
    for (QueryArgs arg in args) {
      ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    var query;
    if (ref != null)
      query = ref.snapshots();
    else
      query = collref.snapshots();
    return query.map((snap) =>
        snap.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Future<List<T>> getListFromTo(String field, DateTime from, DateTime to,
      {List<QueryArgs> args = const []}) async {
    var ref = _db.collection(collection).orderBy(field);
    for (QueryArgs arg in args) {
      ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    QuerySnapshot query = await ref.startAt([from]).endAt([to]).getDocuments();
    return query.documents
        .map((doc) => fromDS(doc.documentID, doc.data))
        .toList();
  }

  Stream<List<T>> streamListFromTo(String field, DateTime from, DateTime to,
      {List<QueryArgs> args = const []}) {
    var ref = _db.collection(collection).orderBy(field, descending: true);
    for (QueryArgs arg in args) {
      ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    var query = ref.startAfter([to]).endAt([from]).snapshots();
    return query.map((snap) =>
        snap.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Future<dynamic> createItem(T item, {String id}) {
    if (id != null) {
      return _db.collection(collection).document(id).setData(toMap(item));
    } else {
      return _db.collection(collection).add(toMap(item));
    }
  }

  Future<dynamic> createMasterItem(T item, {String id}) {
    if (id != null) {
      return _db.collection(collection).document(id).setData(toMap(item));
    } else {
      return _db.collection(collection).add(toMap(item));
    }
  }

  Future<void> updateItem(T item) {
    return _db
        .collection(collection)
        .document(item.id)
        .setData(toMap(item), merge: true);
  }

  Future<void> removeItem(String id) {
    return _db.collection(collection).document(id).delete();
  }
}

class QueryArgs {
  final String key;
  final dynamic value;

  QueryArgs(this.key, this.value);
}

DatabaseService<Note> personalnotesDb = DatabaseService<Note>(PERSONAL_COLLECTION,
    fromDS: (id, data) => Note.fromDS(id, data), toMap: (note) => note.toMap());

DatabaseService<MasterNote> masternotesDb = DatabaseService<MasterNote>(
    MASTER_COLLECTION,
    fromDS: (id, data) => MasterNote.fromDS(id, data),
    toMap: (masternote) => masternote.toMap()); 

DatabaseService<GroupMessage> grpMsgDb = DatabaseService<GroupMessage>(
    GROUP_MESSAGES,
    fromDS: (id, data) => GroupMessage.fromDS(id, data),
    toMap: (masternote) => masternote.toMap()); 
