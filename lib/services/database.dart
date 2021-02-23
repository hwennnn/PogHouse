import 'package:firebase_auth/firebase_auth.dart';
import 'package:poghouse/app/model/rooms.dart';
import 'package:uuid/uuid.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> createUser(User user);
  Future<void> setRoom(Room room);
  Future<void> deleteRoom(Room room);
  Stream<List<Room>> roomsStream();
}

String get documentId => Uuid().v4();

class FirestoreDatabase implements Database {
  FirestoreDatabase();

  final _service = FirestoreService.instance;

  Future<void> createUser(User user) async {
    _service.setData(
      path: APIPath.user(user.uid),
      data: {
        'id': user.uid,
        'nickname': user.displayName,
        'photoUrl': user.photoURL
      },
    );
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
}
