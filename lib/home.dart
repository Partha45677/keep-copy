import 'package:flutter/material.dart';
import 'package:keepnote/CreateNote.dart';
import 'package:keepnote/NoteShow.dart';
import 'package:keepnote/SearchPage.dart';
import 'package:keepnote/Services/databaseModel.dart';
import 'package:keepnote/Services/db.dart';
import 'package:keepnote/Services/dbprof.dart';
import 'package:keepnote/Services/firestoredb.dart';
import 'package:keepnote/SideMenuBar.dart';
import 'package:keepnote/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keepnote/Services/auth.dart';
import 'package:keepnote/loginScreen.dart';

class homi extends StatefulWidget {
  const homi({super.key});

  @override
  State<homi> createState() => _homiState();
}

class _homiState extends State<homi> {
  GlobalKey<ScaffoldState> _drawerkey = GlobalKey();
  bool isLoading = true;
  bool isGridView = true;
  late List<Note> notesList, notePin;
  late String imgUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readEntry();
  }

  Future createEntry(Note note) async {
    await NotesDatabase.instance.insertEntry(note);
  }

  Future readEntry() async {
    LocalDataSaver.getImg().then((value) {
      if (this.mounted) {
        setState(() {
          imgUrl = value!;
        });
      }
    });
    this.notesList = await NotesDatabase.instance.readNormaldNotes();
    this.notePin = await NotesDatabase.instance.readpinedNotes();
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
            endDrawerEnableOpenDragGesture: true,
            key: _drawerkey,
            drawer: Sidebar(),
            backgroundColor: bgColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      decoration: BoxDecoration(
                          color: cardColor,
                          boxShadow: [
                            BoxShadow(
                                color: black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3)
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _drawerkey.currentState!.openDrawer();
                                },
                                icon: Icon(
                                  Icons.menu,
                                  color: white,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => search()));
                                },
                                child: Container(
                                  height: 55,
                                  width: 180,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Search Notes",
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                    setState(() {
                                      isGridView = !isGridView;
                                    });
                                  },
                                  child: Icon(
                                    isGridView ? Icons.grid_view : Icons.list,
                                    color: white,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext) {
                                          return profiles();
                                        });
                                  },
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white,
                                    onBackgroundImageError:
                                        (Object, StackTrace) {
                                      print("ok");
                                    },
                                    backgroundImage:
                                        NetworkImage(imgUrl.toString()),
                                  ),
                                ),
                                SizedBox(
                                  width: 0,
                                )
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
                            "ALL",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    NoteSectionCOLOR(),
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
        : Container(
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

  Widget NoteSectionCOLOR() {
    return isGridView
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: notePin.length,
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
                                note: notePin[index],
                              )));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                      color: index.isEven
                          ? Colors.green.withOpacity(0.8)
                          : Colors.blue.withOpacity(0.4),
                      border: Border.all(color: white.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notePin[index].title,
                        style: TextStyle(color: white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        notePin[index].content.length > 250
                            ? "${notePin[index].content.substring(0, 250)}...."
                            : notePin[index].content,
                        style: TextStyle(color: white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: notePin.length,
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
                    borderRadius: BorderRadius.circular(7),
                    color: index.isEven
                        ? Colors.green.withOpacity(0.8)
                        : Colors.blue.withOpacity(0.4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notePin[index].title,
                        style: TextStyle(color: white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        notePin[index].content.length > 250
                            ? "${notePin[index].content.substring(0, 250)}...."
                            : notePin[index].content,
                        style: TextStyle(color: white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget profiles() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: cardColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 70),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(imgUrl.toString()),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              constant.name,
              style: TextStyle(
                  color: white, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              constant.email,
              style: TextStyle(
                  color: white, fontSize: 19, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () async {
                signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => login()));
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(25)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      Text(
                        "Sign Out",
                        style: TextStyle(
                            color: black,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
