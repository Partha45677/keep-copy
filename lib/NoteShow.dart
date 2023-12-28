import 'package:flutter/material.dart';
import 'package:keepnote/Archieve.dart';
import 'package:keepnote/EditPage.dart';
import 'package:keepnote/Services/databaseModel.dart';
import 'package:keepnote/Services/db.dart';
import 'package:keepnote/colors.dart';
import 'package:keepnote/home.dart';

class noteview extends StatefulWidget {
  Note note;
  noteview({required this.note});

  @override
  State<noteview> createState() => _noteviewState();
}

class _noteviewState extends State<noteview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: white,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/back');
          },
        ),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () async {
                await NotesDatabase.instance.pinNote(widget.note);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => homi()));
              },
              icon: Icon(
                widget.note.pin ? Icons.push_pin : Icons.push_pin_outlined,
                color: white,
              )),
          IconButton(
              onPressed: () async {
                await NotesDatabase.instance.archieNote(widget.note);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => archieve()));
              },
              icon: Icon(
                widget.note.isArchieve ? Icons.archive : Icons.archive_outlined,
                color: white,
              )),
          IconButton(
              onPressed: () async {
                await NotesDatabase.instance.deleteNote(widget.note);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => homi()));
              },
              icon: Icon(
                Icons.delete,
                color: white,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => editview(note: widget.note)));
              },
              icon: Icon(
                Icons.edit_outlined,
                color: white,
              ))
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.title,
              style: TextStyle(
                  color: white, fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.note.content,
              style: TextStyle(color: white),
            )
          ],
        ),
      ),
    );
  }
}
