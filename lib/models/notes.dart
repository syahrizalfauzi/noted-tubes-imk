import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String noteId;
  final String title;
  final String content;
  final DateTime lastEdit;

  Note(this.noteId, this.title, this.content, this.lastEdit);

  String get lastEditText => "${lastEdit.day}/${lastEdit.month}/${lastEdit.year}";

  factory Note.fromSnapshot(QueryDocumentSnapshot snapshot) {
    String lastEditString = snapshot.data()['lastEdit'] as String;
    return Note(
      snapshot.id,
      snapshot.data()['title'],
      snapshot.data()['content'],
      DateTime.parse(lastEditString),
    );
  }

  // Map<String, dynamic> toSnapshot() {
  //   return {"title": title, "content": content, "lastEdit": "${lastEdit.year}/${lastEdit.month}/${lastEdit.day}"};
  // }

  bool isModified(String newTitle, String newContent) {
    return newTitle != this.title || newContent != this.content;
  }
}
