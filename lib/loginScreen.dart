import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:keepnote/Services/auth.dart';
import 'package:keepnote/Services/dbprof.dart';
import 'package:keepnote/Services/firestoredb.dart';
import 'package:keepnote/colors.dart';
import 'package:keepnote/home.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  Future<void> checkUserLog() async {
    final FirebaseAuth auth = await FirebaseAuth.instance;
    final user = await auth.currentUser;
    if (user != null) {
      constant.name = (await LocalDataSaver.getName())!;
      constant.email = (await LocalDataSaver.getEmail())!;
      constant.img = (await LocalDataSaver.getImg())!;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homi()));
      await FireDB().getAllStoredNotes();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserLog();
  }

  signInMethod(context) async {
    await signInWithGoogle();
    constant.name = (await LocalDataSaver.getName())!;
    constant.email = (await LocalDataSaver.getEmail())!;
    constant.img = (await LocalDataSaver.getImg())!;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => homi()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          "Login To Keep Note",
          style: TextStyle(color: white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("asset/keep.jpg"),
            SizedBox(
              height: 15,
            ),
            SignInButton(Buttons.Google, onPressed: () async {
              signInMethod(context);
            })
          ],
        ),
      ),
    );
  }
}
