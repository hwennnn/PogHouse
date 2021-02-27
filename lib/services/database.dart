import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poghouse/app/model/message.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:uuid/uuid.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> createPeople(People people);
  Future<List<People>> retrieveAllPeople();
  Future<People> retrieveSinglePeople(String uid);
  Future<List<People>> retrieveRoomMembers(Room room);
  Future<void> setFavorite(String uid, People people);
  Future<void> removeFavorite(String uid, People people);
  Future<void> setRoom(Room room);
  Future<void> deleteRoom(Room room);
  Future<void> addRoomToPeople(Room room);
  Future<void> setMessage(Message message);
  Stream<DocumentSnapshot> roomStream(String id);
  Stream<List<Room>> roomsStream(String uid);
  Stream<List<People>> peopleStream();
  Stream<List<People>> favoriteStream(String uid);
  Stream<List<Message>> messagesStream(String roomID);
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

  Future<People> retrieveSinglePeople(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('people').doc(uid).get();
    People people = People.fromMap(snapshot.data());
    return people;
  }

  Future<List<People>> retrieveRoomMembers(Room room) async {
    List<String> members = [room.owner, ...room.members];
    List<People> result = [];
    for (String uid in members) {
      final People people = await retrieveSinglePeople(uid);
      result.add(people);
    }

    return result;
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

  Future<void> addRoomToPeople(Room room) async {
    List<String> members = [room.owner, ...room.members];
    for (String id in members) {
      final user = FirebaseFirestore.instance.collection('people').doc(id);
      await user.collection('rooms').doc(room.id).set({
        'id': room.id,
      });
    }
  }

  Future<void> setMessage(Message message) async {
    final user =
        FirebaseFirestore.instance.collection('rooms').doc(message.roomID);
    await user.collection('messages').doc(message.id).set(
          message.toMap(),
        );
  }

  Stream<DocumentSnapshot> roomStream(String id) =>
      _service.roomCollectionStream(
        roomID: id,
        builder: (data) => Room.fromMap(data),
      );

  Stream<List<Room>> roomsStream(String uid) => _service.roomsCollectionStream(
        uid: uid,
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

  Stream<List<Message>> messagesStream(String roomID) =>
      _service.messagesCollectionStream(
        roomID: roomID,
        builder: (data) => Message.fromMap(data),
      );
}
