import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreController {
  final _firestore = FirebaseFirestore.instance;

  Future<void> insertNewUser(User user) async {
    CollectionReference users = _firestore.collection('users');

    DocumentSnapshot result = await users.doc(user.uid).get();
    print(result.exists);
    if (!result.exists) {
      print("insert new user");
      await users.doc(user.uid).set({
        'nickname': user.displayName,
        'photoUrl': user.photoURL,
        'id': user.uid
      });
    }

    // final QuerySnapshot result = await Firestore.instance
    //     .collection('users')
    //     .where('id', isEqualTo: user.uid)
    //     .getDocuments();
    // final List<DocumentSnapshot> documents = result.documents;
    // if (documents.length == 0) {
    //   // Update data to server if new user
    //   Firestore.instance.collection('users').document(user.uid).setData({
    //     'nickname': user.displayName,
    //     'photoUrl': user.photoUrl,
    //     'id': user.uid
    //   });
    // }
  }
}
