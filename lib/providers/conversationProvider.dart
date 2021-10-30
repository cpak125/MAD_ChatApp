import 'package:chatapp/models/convo.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/views/home_builder.dart';
import 'package:chatapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationProvider extends StatelessWidget {
  const ConversationProvider({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Convo>>.value(
        value: Database.streamConversations(user.uid),
        initialData: [],
        child: ConversationDetailsProvider(user: user));
  }
}

class ConversationDetailsProvider extends StatelessWidget {
  const ConversationDetailsProvider({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  // Widget build(BuildContext context) {
  //   return StreamProvider<List<UserEX>>.value(
  //       value: Database.streamUsers(), initialData: [], child: HomeBuilder());
  // }

  Widget build(BuildContext context) {
    return StreamProvider<List<UserEX>>.value(
        value: Database.streamUsers(), initialData: [], child: HomeBuilder());
  }

  // List<String> getUserIds(List<Convo> _convos) {
  //   final List<String> users = <String>[];
  //   for (Convo c in _convos) {
  //     (c.userIds[0] != user.uid)
  //         ? users.add(c.userIds[0])
  //         : users.add(c.userIds[1]);
  //   }
  //   return users;
  // }
}
