import 'package:bubble/bubble.dart';
import 'package:chatapp/views/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/services/database.dart';

class NewConversationScreen extends StatelessWidget {
  const NewConversationScreen(
      {required this.uid, required this.contact, required this.convoID});
  final String uid, convoID;
  final UserEX contact;

  double avgRatings(List<dynamic> ratings) {
    double average = ratings.reduce((a, b) => a + b) / ratings.length;
    return double.parse(average.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
              child: Text("Avg rating: ${avgRatings(contact.ratings)} ",
                  style: TextStyle(fontSize: 18)),
              preferredSize: new Size.fromHeight(10.0)),
          backgroundColor: Colors.teal.shade300,
          title: Text(contact.name),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()))),
        ),
        body: ChatScreen(uid: uid, convoID: convoID, contact: contact));
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {required this.uid, required this.convoID, required this.contact});
  final String uid, convoID;
  final UserEX contact;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final String uid, convoID;
  late UserEX contact;
  late List<DocumentSnapshot> listMessage;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    convoID = widget.convoID;
    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildMessages(),
              buildInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              // Edit text
              Flexible(
                child: Container(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        autofocus: true,
                        maxLines: 5,
                        controller: textEditingController,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Type your message...',
                        ),
                      )),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send, size: 25),
                  onPressed: () => onSendMessage(textEditingController.text),
                ),
              ),
            ],
          ),
        ),
        width: double.infinity,
        height: 100.0);
  }

  Widget buildMessages() {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(convoID)
            .collection(convoID)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) =>
                  buildItem(index, snapshot.data!.docs[index]),
              itemCount: snapshot.data!.docs.length,
              reverse: true,
              controller: listScrollController,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (!document['read'] && document['idTo'] == uid) {
      Database.updateMessageRead(document, convoID);
    }

    if (document['idFrom'] == uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          // Text
          Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Bubble(
                  color: Colors.blueGrey,
                  elevation: 0,
                  padding: const BubbleEdges.all(10.0),
                  nip: BubbleNip.rightTop,
                  child: Text(document['content'],
                      style: TextStyle(color: Colors.white, fontSize: 16))),
              width: 200)
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                child: Bubble(
                    color: Colors.white10,
                    elevation: 0,
                    padding: const BubbleEdges.all(10.0),
                    nip: BubbleNip.leftTop,
                    child: Text(document['content'],
                        style: TextStyle(color: Colors.white, fontSize: 16))),
                width: 200.0,
                margin: const EdgeInsets.only(left: 10.0),
              )
            ])
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      content = content.trim();
      Database.sendMessage(convoID, uid, contact.id, content,
          DateTime.now().millisecondsSinceEpoch.toString());
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
