import 'dart:ui';
import 'package:chatapp/models/convo.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/providers/newMessageProvider.dart';
import 'package:chatapp/views/home_view.dart';
import 'package:chatapp/widgets/convoWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBuilder extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User firebaseUser = Provider.of<User>(context);
    final List<UserEX> _users = Provider.of<List<UserEX>>(context);
    final List<Convo> _convos = Provider.of<List<Convo>>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal.shade300,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "${_auth.currentUser!.email}",
              ),
              FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.red.shade400,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: Text(
                              'Are you sure you want to log out?',
                              style: TextStyle(fontSize: 20),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red.shade800)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'NO',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green.shade800)),
                                  onPressed: () {
                                    _signOut(context);
                                  },
                                  child: Text(
                                    'YES',
                                    style: TextStyle(fontSize: 20),
                                  ))
                            ]);
                      });
                },
                tooltip: 'Log Out',
                child: Icon(
                  Icons.logout,
                ),
              )
            ],
          ),
        ),
        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: getWidgets(context, firebaseUser, _convos, _users)),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () => createNewConvo(context),
          child: Icon(Icons.add),
          backgroundColor: Colors.teal.shade300,
          foregroundColor: Colors.white,
        ));
  }

  void _signOut(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    await _auth.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('User logged out.')));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (con) => Home()));
  }

  void createNewConvo(BuildContext context) {
    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => NewMessageProvider()));
  }

  Map<String, UserEX> getUserMap(List<UserEX> users) {
    Map<String, UserEX> userMap = <String, UserEX>{};
    for (UserEX u in users) {
      if (u.id != _auth.currentUser!.uid) {
        userMap[u.id] = u;
      }
    }
    return userMap;
  }

  List<Widget> getWidgets(BuildContext context, User user, List<Convo> _convos,
      List<UserEX> _users) {
    final List<Widget> list = [];
    // ignore: unnecessary_null_comparison
    if (_convos != null && _users != null && user != null) {
      final Map<String, UserEX> userMap = getUserMap(_users);
      for (Convo c in _convos) {
        if (c.userIds[0] == user.uid) {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[1]]!,
              lastMessage: c.lastMessage));
        } else {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[0]]!,
              lastMessage: c.lastMessage));
        }
      }
    }
    return list;
  }
}
