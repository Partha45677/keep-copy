import 'package:flutter/material.dart';
import 'package:keepnote/colors.dart';
import 'package:keepnote/Services/auth.dart';
import 'package:keepnote/loginScreen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool value = false;
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
        title: Text(
          "Settings",
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Row(
            children: [
              Text(
                "Sync",
                style: TextStyle(color: Colors.white, fontSize: 19),
              ),
              Spacer(),
              Transform.scale(
                scale: 1,
                child: Switch.adaptive(
                    value: value,
                    onChanged: (switchValue) {
                      setState(() {
                        this.value = switchValue;
                      });
                    }),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
