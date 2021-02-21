import 'package:flutter/material.dart';
import 'package:poghouse/app/sign_in/social_sign_in_button.dart';
import 'package:poghouse/common_widgets/loading.dart';
import 'package:poghouse/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;

  Future<void> _signInWithGoogle() async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    this.setState(() {
      isLoading = true;
    });

    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<void> _signInWithFacebook() async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    this.setState(() {
      isLoading = true;
    });

    try {
      await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }

    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PogHouse'),
        elevation: 2.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
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
                onPressed: _signInWithGoogle,
              ),
              SizedBox(height: 8.0),
              SocialSignInButton(
                assetName: 'images/facebook-logo.png',
                text: 'Sign in with Facebook',
                textColor: Colors.white,
                color: Color(0xFF334D92),
                onPressed: _signInWithFacebook,
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
