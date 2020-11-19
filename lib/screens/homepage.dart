import 'package:flutter/material.dart';
import 'package:noted/constants.dart';
import 'package:noted/models/notes.dart';
import '../models/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Note> dumbNotes = [
  //   Note('1', 'Judul', 'Isi \naaaaaaaasdasdasdaaaaaaaaaaaaaaa', DateTime.now()),
  //   Note(
  //       '2',
  //       'Judul',
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  //       DateTime.now()),
  //   Note('3', 'Judul', 'Isi', DateTime.now()),
  //   Note('4', 'Judul', 'Isi', DateTime.now()),
  // ];

  List<Note> notes = [];

  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  List<Note> displayedNotes = [];
  TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    setState(() {
      _isFetching = true;
    });
    print('FETCHING NOTES');
    var noteSnapshot = await _collectionReference.doc(_auth.currentUser.uid).collection('notes').get();
    setState(() {
      notes = noteSnapshot.docs.map((e) => Note.fromSnapshot(e)).toList();
      displayedNotes = notes;
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var defaultAppBar = AppBar(
      toolbarHeight: 80,
      elevation: 0,
      backgroundColor: putih,
      title: Text('Notes', style: headerStyle),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          color: hitam,
          onPressed: () => setState(() => _isSearching = true),
        ),
        IconButton(
          icon: Icon(Icons.settings),
          color: hitam,
          onPressed: () => Navigator.pushNamed(context, '/home/settings').then((value) => setState(() {})),
        ),
      ],
    );
    var searchAppBar = AppBar(
      toolbarHeight: 80,
      elevation: 0,
      backgroundColor: putih,
      title: Row(
        children: [
          Expanded(
            child: TextField(
              style: textStyle,
              autofocus: true,
              onChanged: (value) {
                List<Note> filteredNotes = [];
                notes.forEach((note) {
                  if (note.title.toLowerCase().contains(value.toLowerCase()) || note.content.toLowerCase().contains(value.toLowerCase())) filteredNotes.add(note);
                });
                setState(() => displayedNotes = filteredNotes);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            color: hitam,
            onPressed: () => setState(() {
              _searchController.text = '';
              displayedNotes = notes;
              _isSearching = false;
            }),
          ),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: putih,
      appBar: _isSearching ? searchAppBar : defaultAppBar,
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: _isFetching ? hitam.withOpacity(0.5) : hitam,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(blurRadius: 10, color: hitam.withOpacity(0.2), offset: Offset(0, 2))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isFetching
                ? null
                : () {
                    Navigator.pushNamed(context, '/home/note', arguments: Note('', 'New note', '', DateTime.now())).then((value) {
                      if (value == true) fetchNotes();
                    });
                  },
            child: Container(
              width: 50,
              height: 50,
              child: Icon(Icons.add, color: putih),
            ),
          ),
        ),
      ),
      body: _isFetching
          ? Center(child: CircularProgressIndicator())
          : displayedNotes.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: fetchNotes,
                  child: ListView.builder(
                    itemCount: displayedNotes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: abu, width: 1),
                          boxShadow: [BoxShadow(blurRadius: 15, color: abu.withOpacity(0.2), offset: Offset(0, 3))],
                          color: putih,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: abu,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(displayedNotes[index].title, style: titleStyle),
                                  SizedBox(height: 12),
                                  Text(
                                    displayedNotes[index].content,
                                    style: textStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12),
                                  Text('Last edited ${displayedNotes[index].lastEditText}', style: trailingStyle)
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/home/note', arguments: displayedNotes[index]).then((value) {
                                if (value == true) fetchNotes();
                              });
                            },
                            onLongPress: () {
                              String title = displayedNotes[index].title;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete Note'),
                                    content: Text("Are you sure you want to delete '$title'?"),
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
                                          var documentRef = FirebaseFirestore.instance.collection('users').doc(_auth.currentUser.uid).collection('notes').doc(displayedNotes[index].noteId);
                                          await documentRef.delete();
                                          setState(() {
                                            _isFetching = true;
                                            notes.removeWhere((element) => element.noteId == displayedNotes[index].noteId);
                                            displayedNotes = notes;
                                            _isFetching = false;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text('Delete', style: textStyle.copyWith(color: merah)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(child: Text(_isSearching ? 'Nothing found :(' : 'Take your first note!', style: textStyle)),
    );
  }
}
