import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/models/convo.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<List<UserEX>> streamUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot doc) =>
                UserEX.fromMap(doc.data()! as Map<String, dynamic>))
            .toList())
        .handleError((dynamic e) {
      print(e);
    });
  }

  static Stream<List<UserEX>> getUsersByList(List<String> userIds) {
    final List<Stream<UserEX>> streams = [];
    for (String id in userIds) {
      streams.add(_db.collection('users').doc(id).snapshots().map(
          (DocumentSnapshot snap) =>
              UserEX.fromMap(snap.data() as Map<String, dynamic>)));
    }
    return StreamZip<UserEX>(streams).asBroadcastStream();
  }

  static Stream<List<Convo>> streamConversations(String uid) {
    return _db
        .collection('messages')
        .orderBy('lastMessage.timestamp', descending: true)
        .where('users', arrayContains: uid)
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot doc) => Convo.fromFireStore(doc))
            .toList());
  }

  static void sendMessage(
    String convoID,
    String id,
    String pid,
    String content,
    String timestamp,
  ) {
    final DocumentReference convoDoc =
        FirebaseFirestore.instance.collection('messages').doc(convoID);

    convoDoc.set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': id,
        'idTo': pid,
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': <String>[id, pid],
      'rating': 0.0
    }).then((dynamic success) {
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('messages')
          .doc(convoID)
          .collection(convoID)
          .doc(timestamp);

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        transaction.set(
          messageDoc,
          <String, dynamic>{
            'idFrom': id,
            'idTo': pid,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          },
        );
      });
    });
  }

  static void updateMessageRead(DocumentSnapshot doc, String convoID) {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(convoID)
        .doc(doc.id);

    documentReference
        .set(<String, dynamic>{'read': true}, SetOptions(merge: true));
  }

  static void updateLastMessage(
      DocumentSnapshot doc, String uid, String pid, String convoID) {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('messages').doc(convoID);

    documentReference
        .set(<String, dynamic>{
          'lastMessage': <String, dynamic>{
            'idFrom': doc['idFrom'],
            'idTo': doc['idTo'],
            'timestamp': doc['timestamp'],
            'content': doc['content'],
            'read': doc['read']
          },
          'users': <String>[uid, pid]
        })
        .then((dynamic success) {})
        .catchError((dynamic error) {
          print(error);
        });
  }

  static void submitConvoRating(String convoID, double rating, UserEX peer) {
    _db
        .collection('messages')
        .doc(convoID)
        .set(<String, dynamic>{'rating': rating}, SetOptions(merge: true));

    _db.collection('users').doc(peer.id).update({
      'ratings': FieldValue.arrayUnion([rating])
    });
  }
}
