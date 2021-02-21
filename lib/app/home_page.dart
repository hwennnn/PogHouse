import 'package:flutter/material.dart';
import 'package:poghouse/common_widgets/show_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/firestoreController.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestoreController = new FirestoreController();

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );

    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  Future<void> _pressed() async {
    await FirestoreController().insertNewUser(widget.auth.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: Center(
        child: Image.network(widget.auth.profilePic),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _pressed,
      ),
    );
  }
}
