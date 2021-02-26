import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:uuid/uuid.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> createPeople(People people);
  Future<List<People>> retrieveAllPeople();
  Future<void> setFavorite(String uid, People people);
  Future<void> removeFavorite(String uid, People people);
  Future<void> setRoom(Room room);
  Future<void> deleteRoom(Room room);
  Stream<List<Room>> roomsStream();
  Stream<List<People>> peopleStream();
  Stream<List<People>> favoriteStream(String uid);
}

String get documentId => Uuid().v4();

class FirestoreDatabase implements Database {
  FirestoreDatabase();

  final _service = FirestoreService.instance;

  Future<void> createPeople(People people) async {
    _service.setData(
      path: APIPath.aPeople(people.id),
      data: people.toMap(),
    );
  }

  Future<List<People>> retrieveAllPeople() async {
    final snapshots =
        await FirebaseFirestore.instance.collection('people').get();
    List<People> people =
        snapshots.docs.map((doc) => People.fromMap(doc.data())).toList();
    return people;
  }

  Future<void> setFavorite(String uid, People people) async {
    final user = FirebaseFirestore.instance.collection('people').doc(uid);
    await user.collection('favorite').doc(people.id).set(
          people.toMap(),
        );
  }

  Future<void> removeFavorite(String uid, People people) async {
    final user = FirebaseFirestore.instance.collection('people').doc(uid);
    await user.collection('favorite').doc(people.id).delete();
  }

  Future<void> setRoom(Room room) => _service.setData(
        path: APIPath.room(room.id),
        data: room.toMap(),
      );

  Future<void> deleteRoom(Room room) => _service.deleteData(
        path: APIPath.room(room.id),
      );

  Stream<List<Room>> roomsStream() => _service.collectionStream(
        path: APIPath.rooms(),
        builder: (data) => Room.fromMap(data),
      );

  Stream<List<People>> peopleStream() => _service.collectionStream(
        path: APIPath.people(),
        builder: (data) => People.fromMap(data),
      );

  Stream<List<People>> favoriteStream(String uid) =>
      _service.favoriteCollectionStream(
        uid: uid,
        builder: (data) => People.fromMap(data),
      );
}
