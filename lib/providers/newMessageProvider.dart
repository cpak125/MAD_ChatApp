import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/new_message_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/models/user.dart';

class NewMessageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserEX>>.value(
      value: Database.streamUsers(),
      initialData: [],
      child: NewMessageScreen(),
    );
  }
}
