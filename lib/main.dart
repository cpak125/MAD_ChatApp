/*
This program was adapated from a post by Yoganathan Shiv at 
https://medium.com/flutter-community/a-chat-application-flutter-firebase-1d2e87ace78f

(Source: https://github.com/Xenon-Labs/Flutter-Development/tree/master/chat_app)
*/

import 'package:chatapp/providers/providerInit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SomethingWentWrong();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ProviderInit();
            } else {
              return Container(color: Colors.yellow);
            }
          },
        ),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
    );
  }
}
