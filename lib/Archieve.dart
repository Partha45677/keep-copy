import 'package:flutter/material.dart';
import 'package:keepnote/CreateNote.dart';
import 'package:keepnote/NoteShow.dart';
import 'package:keepnote/SearchPage.dart';
import 'package:keepnote/Services/databaseModel.dart';
import 'package:keepnote/Services/db.dart';
import 'package:keepnote/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class archieve extends StatefulWidget {
  const archieve({super.key});

  @override
  State<archieve> createState() => _homiState();
}

class _homiState extends State<archieve> {
  bool isLoading = true;
  bool isGridView = true;
  late List<Note> notesList;
  @override
  void initState() {
    super.initState();
    readEntry();
  }

  Future createEntry(Note note) async {
    await NotesDatabase.instance.insertEntry(note);
  }

  Future readEntry() async {
    this.notesList = await NotesDatabase.instance.readArchivedNotes();
    setState(() {
      isLoading = false;
    });
  }

  Future readOneEntry(int id) async {
    await NotesDatabase.instance.readOneNote(id);
  }

  Future updateOneEntry(Note note) async {
    await NotesDatabase.instance.updateNote(note);
  }

  Future deleteOneEntry(Note note) async {
    await NotesDatabase.instance.deleteNote(note);
  }

  Future closeDatab() async {
    await NotesDatabase.instance.closeDB();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyWidget()));
              },
              backgroundColor: cardColor,
              child: Icon(
                Icons.add,
                size: 45,
                color: white,
              ),
            ),
            backgroundColor: bgColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: Row(
                        children: [
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: white,
                                  size: 25,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Container(
                                height: 55,
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Archive",
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            child: Row(
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => white.withOpacity(0.1)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => search()));
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: white,
                                  ),
                                ),
                                SizedBox(
                                  width: 0,
                                ),
                                IconButton(
                                    style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateColor.resolveWith(
                                              (states) =>
                                                  white.withOpacity(0.1)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isGridView = !isGridView;
                                      });
                                    },
                                    icon: Icon(
                                      isGridView ? Icons.grid_view : Icons.list,
                                      color: white,
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Secrete",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    NoteSectionAll(),
                  ]),
                ),
              ),
            ),
          );
  }

  Widget NoteSectionAll() {
    return isGridView
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: notesList.length,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              crossAxisCount: 4,
              staggeredTileBuilder: (index) => StaggeredTile.fit(2),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => noteview(
                                note: notesList[index],
                              )));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: white.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notesList[index].title,
                        style: TextStyle(color: white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        notesList[index].content.length > 250
                            ? "${notesList[index].content.substring(0, 250)}...."
                            : notesList[index].content,
                        style: TextStyle(color: white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : NoteListView();
  }

  Widget NoteListView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: notesList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => noteview(
                          note: notesList[index],
                        )));
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
                border: Border.all(color: white.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(7)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notesList[index].title,
                  style: TextStyle(color: white, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  notesList[index].content.length > 250
                      ? "${notesList[index].content.substring(0, 250)}...."
                      : notesList[index].content,
                  style: TextStyle(color: white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
