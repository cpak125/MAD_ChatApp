import 'package:cloud_firestore/cloud_firestore.dart';

class Convo {
  Convo(
      {required this.id,
      required this.userIds,
      required this.lastMessage,
      required this.rating});

  factory Convo.fromFireStore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Convo(
        id: doc.id,
        rating: data['rating'],
        userIds: data['users'] ?? <dynamic>[],
        lastMessage: data['lastMessage'] ?? <dynamic>{});
  }

  final String id;
  final List<dynamic> userIds;
  final Map<dynamic, dynamic> lastMessage;
  final double rating;
}

class Message {
  Message(
      {required this.id,
      required this.content,
      required this.idFrom,
      required this.idTo,
      required this.timestamp});

  factory Message.fromFireStore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data as Map<String, dynamic>;

    return Message(
        id: doc.id,
        content: data['content'],
        idFrom: data['idFrom'],
        idTo: data['idTo'],
        timestamp: data['timestamp']);
  }

  final String id;
  final String content;
  final String idFrom;
  final String idTo;
  final DateTime timestamp;
}
