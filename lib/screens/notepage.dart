import 'package:flutter/material.dart';
import 'package:noted/models/notes.dart';
import '../models/textstyles.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Note currentNote;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentReference documentRef;

  bool _isInitialized = false;

  void initialize() {
    _isInitialized = true;
    setState(() {
      currentNote = ModalRoute.of(context).settings.arguments;
      _titleController.text = currentNote.title ?? '';
      _contentController.text = currentNote.content ?? '';
    });
    if (currentNote.noteId != '') documentRef = FirebaseFirestore.instance.collection('users').doc(_auth.currentUser.uid).collection('notes').doc(currentNote.noteId);
  }

  Future<void> fetchNotes() async {}

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) initialize();
    return WillPopScope(
      onWillPop: () {
        FocusScope.of(context).unfocus();
        if (currentNote.isModified(_titleController.text, _contentController.text))
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Unsaved Changes'),
                content: Text("You haven't saved this note"),
                titleTextStyle: titleStyle,
                contentTextStyle: textStyle,
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel', style: textStyle),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Discard', style: textStyle.copyWith(color: merah)),
                  ),
                ],
              );
            },
          );
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: hitam),
          elevation: 0,
          backgroundColor: putih,
          actions: [
            if (currentNote.noteId != '')
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: currentNote.noteId.isNotEmpty
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete Note'),
                              content: Text("Are you sure you want to delete '${currentNote.title}'?"),
                              titleTextStyle: titleStyle,
                              contentTextStyle: textStyle,
                              actions: [
                                FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel', style: textStyle),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    await documentRef.delete();
                                    Navigator.pop(context);
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('Delete', style: textStyle.copyWith(color: merah)),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : null,
              ),
            IconButton(
              icon: Icon(Icons.done),
              color: Colors.green,
              onPressed: !currentNote.isModified(_titleController.text, _contentController.text)
                  ? null
                  : () async {
                      if (currentNote.noteId != '')
                        await documentRef.set({
                          "title": _titleController.text,
                          "content": _contentController.text,
                          "lastEdit": "${currentNote.lastEdit.year}-${currentNote.lastEdit.month}-${currentNote.lastEdit.day}",
                        });
                      else {
                        var collectionReference = FirebaseFirestore.instance.collection('users').doc(_auth.currentUser.uid).collection('notes');
                        await collectionReference.add({
                          "title": _titleController.text,
                          "content": _contentController.text,
                          "lastEdit": "${currentNote.lastEdit.year}-${currentNote.lastEdit.month}-${currentNote.lastEdit.day}",
                        });
                      }
                      Navigator.pop(context, true);
                    },
            ),
          ],
        ),
        backgroundColor: putih,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                autofocus: currentNote.noteId.isEmpty ? true : false,
                maxLines: 1,
                style: titleStyle,
                onSubmitted: (value) {
                  _focusNode.requestFocus();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SelectableText(currentNote.lastEditText, style: subtitleStyle),
              SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  focusNode: _focusNode,
                  autofocus: currentNote.noteId.isNotEmpty ? true : false,
                  textInputAction: TextInputAction.newline,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  style: textStyle,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Put your notes here...',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
