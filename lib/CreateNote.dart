import 'package:flutter/material.dart';
import 'package:keepnote/Services/databaseModel.dart';
import 'package:keepnote/Services/db.dart';
import 'package:keepnote/colors.dart';
import 'package:keepnote/home.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  TextEditingController title = new TextEditingController();
  TextEditingController content = new TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title.dispose();
    content.dispose();
  }

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
            icon: Icon(Icons.save_outlined),
            color: white,
            onPressed: () async {
              await NotesDatabase.instance.insertEntry(Note(
                  pin: false,
                  isArchieve: false,
                  title: title.text,
                  content: content.text,
                  createdTime: DateTime.now()));
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (content) => homi()));
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(children: [
          TextField(
            cursorColor: white,
            controller: title,
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
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
          Container(
            height: 300,
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 50,
              maxLines: null,
              cursorColor: white,
              controller: content,
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
          )
        ]),
      ),
    );
  }
}
