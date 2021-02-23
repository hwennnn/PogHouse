import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreController {
  final _firestore = FirebaseFirestore.instance;

  Future<void> insertNewUser(User user) async {
    CollectionReference users = _firestore.collection('users');
    DocumentSnapshot result = await users.doc(user.uid).get();
    if (!result.exists) {
      await users.doc(user.uid).set({
        'nickname': user.displayName,
        'photoUrl': user.photoURL,
        'id': user.uid
      });
    }
  }
}
