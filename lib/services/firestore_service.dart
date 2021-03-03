import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:poghouse/app/model/rooms.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }

  Stream<List<T>> favoriteCollectionStream<T>({
    @required String uid,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance
        .collection('people')
        .doc(uid)
        .collection('favorite');
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }

  Stream<DocumentSnapshot> roomCollectionStream<T>({
    @required String roomID,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference =
        FirebaseFirestore.instance.collection('rooms').doc(roomID);
    final snapshots = reference.snapshots();
    return snapshots;
  }

  Stream<List<T>> roomsCollectionStream<T>({
    @required String uid,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance
        .collection('people')
        .doc(uid)
        .collection('rooms');
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }

  Stream<List<T>> roomsDetailsCollectionStream<T>({
    @required List<String> roomIDs,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance
        .collection('rooms')
        .where("id", whereIn: roomIDs);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }

  Stream<List<T>> messagesCollectionStream<T>({
    @required String roomID,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomID)
        .collection('messages');
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }
}
