// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:poghouse/main.dart';

import 'firebase_mock.dart';

void main() async {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('HomePage Testing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    print('pump widget');
    await tester.pumpWidget(MyApp());

    print("the homepage is successfully initialised.");
  });
}
