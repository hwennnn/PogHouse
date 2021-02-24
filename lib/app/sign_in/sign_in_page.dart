import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poghouse/app/model/people.dart';
import 'package:poghouse/app/sign_in/sign_in_manager.dart';
import 'package:poghouse/app/sign_in/social_sign_in_button.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/common_widgets/show_exception_alert_dialog.dart';
import 'package:poghouse/services/auth.dart';
import 'package:poghouse/services/database.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    Key key,
    @required this.manager,
    @required this.isLoading,
  }) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) =>
                SignInPage(manager: manager, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final user = await manager.signInWithGoogle();
      final database = Provider.of<Database>(context, listen: false);
      final people = People(
        id: user.uid,
        nickname: user.displayName,
        photoUrl: user.photoURL,
      );
      await database.createPeople(people);
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final user = await manager.signInWithFacebook();
      final database = Provider.of<Database>(context, listen: false);
      final people = People(
        id: user.uid,
        nickname: user.displayName,
        photoUrl: user.photoURL,
      );
      await database.createPeople(people);
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PogHouse'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Sign in to PogHouse',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 48.0),
              SocialSignInButton(
                assetName: 'images/google-logo.png',
                text: 'Sign in with Google',
                textColor: Colors.black87,
                color: Colors.white,
                onPressed: () => _signInWithGoogle(context),
              ),
              SizedBox(height: 8.0),
              SocialSignInButton(
                assetName: 'images/facebook-logo.png',
                text: 'Sign in with Facebook',
                textColor: Colors.white,
                color: Color(0xFF334D92),
                onPressed: () => _signInWithFacebook(context),
              ),
            ],
          ),
        ),

        // Loading
        Positioned(
          child: isLoading ? const Loading() : Container(),
        ),
      ],
    );
  }
}
