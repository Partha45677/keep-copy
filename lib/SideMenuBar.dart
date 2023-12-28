import 'package:flutter/material.dart';
import 'package:keepnote/Archieve.dart';
import 'package:keepnote/colors.dart';
import 'package:keepnote/home.dart';
import 'package:keepnote/setting.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: bgColor),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: Text(
                  "Keep Notes",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: white.withOpacity(0.3),
              ),
              sectionONE(),
              SizedBox(
                height: 5,
              ),
              sectionTWO(),
              SizedBox(
                height: 5,
              ),
              sectionTHREE(),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionONE() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))))),
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homi()));
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: white,
                size: 25,
              ),
              SizedBox(
                width: 27,
              ),
              Text(
                "Notes",
                style: TextStyle(
                  color: white.withOpacity(0.7),
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTWO() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
            // backgroundColor:
            // MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))))),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => archieve()));
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.archive,
                color: white,
                size: 25,
              ),
              SizedBox(
                width: 27,
              ),
              Text(
                "Archive",
                style: TextStyle(
                  color: white.withOpacity(0.7),
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTHREE() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
            // backgroundColor:
            // MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))))),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Setting()));
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.settings,
                color: white,
                size: 25,
              ),
              SizedBox(
                width: 27,
              ),
              Text(
                "Setting",
                style: TextStyle(
                  color: white.withOpacity(0.7),
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
