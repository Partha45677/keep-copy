import 'package:flutter/material.dart';
import 'package:keepnote/NoteShow.dart';
import 'package:keepnote/Services/db.dart';
import 'package:keepnote/colors.dart';
import 'package:keepnote/Services/databaseModel.dart';

class editview extends StatefulWidget {
  Note note;
  editview({required this.note});

  @override
  State<editview> createState() => _editviewState();
}

class _editviewState extends State<editview> {
  late String newTitle;
  late String newContent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.newTitle = widget.note.title.toString();
    this.newContent = widget.note.content.toString();
  }

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
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined),
            color: white,
            onPressed: () async {
              Note newNote = Note(
                  pin: widget.note.pin,
                  isArchieve: widget.note.isArchieve,
                  title: newTitle,
                  content: newContent,
                  createdTime: widget.note.createdTime,
                  id: widget.note.id);
              await NotesDatabase.instance.updateNote(newNote);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => noteview(note: newNote)));
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(children: [
          Form(
            child: TextFormField(
              cursorColor: white,
              initialValue: newTitle,
              onChanged: (value) {
                newTitle = value;
              },
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(0.8))),
            ),
          ),
          Container(
            height: 300,
            child: Form(
              child: TextFormField(
                initialValue: newContent,
                keyboardType: TextInputType.multiline,
                minLines: 50,
                maxLines: null,
                cursorColor: white,
                onChanged: (value) {
                  newContent = value;
                },
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "None",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.8))),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
