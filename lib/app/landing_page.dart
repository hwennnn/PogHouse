import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/home_page.dart';
import 'package:poghouse/app/sign_in/sign_in_page.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/firestoreController.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Provider<FirestoreController>(
      create: (_) => FirestoreController(),
      child: StreamBuilder<User>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return HomePage(auth: auth);
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
