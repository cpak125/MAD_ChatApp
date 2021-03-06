import 'package:flutter/material.dart';
import 'package:chatapp/utils/helperFunctions.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/views/new_conversation_screen.dart';

class UserRow extends StatelessWidget {
  const UserRow({required this.uid, required this.contact});
  final String uid;
  final UserEX contact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => createConversation(context),
      child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: Text(contact.name,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)))),
    );
  }

  void createConversation(BuildContext context) {
    String convoID = HelperFunctions.getConvoID(uid, contact.id);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => NewConversationScreen(
            uid: uid, contact: contact, convoID: convoID)));
  }
}
