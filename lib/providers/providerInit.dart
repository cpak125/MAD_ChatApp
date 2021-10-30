import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/views/home_view.dart';

class ProviderInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
        value: FirebaseAuth.instance.authStateChanges(),
        initialData: null,
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            brightness: Brightness.dark,
          ),
          title: 'Chat Application',
          debugShowCheckedModeBanner: false,
          home: Home(),
        ));
  }
}
