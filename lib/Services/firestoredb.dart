import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keepnote/Services/databaseModel.dart';
import 'package:keepnote/Services/db.dart';

class FireDB {
  // CREATE,READ,UPDATE,DELETE
  final FirebaseAuth _auth = FirebaseAuth.instance;

  createNewNoteFireStore(Note note) async {
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(current_user!.email)
        .collection("usernotes")
        .doc(note.createdTime.toIso8601String())
        .set({
      "Title": note.title,
      "content": note.content,
      "date": note.createdTime,
    }).then((_) {
      print("DATA ADDED SUCESSFULLY");
    });
  }

  getAllStoredNotes() async {
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(current_user!.email)
        .collection("usernotes")
        .orderBy("date")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map note = result.data();

        NotesDatabase.instance.insertEntry(Note(
            pin: false,
            isArchieve: false,
            title: note["title"] ?? "",
            content: note["content"] ?? "",
            createdTime: note["createdTime"] ?? DateTime.now()));
      });
    });
  }

  Future<void> updateNoteFirestore(Note note) async {
    final User? current_user = _auth.currentUser;

    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(current_user?.email)
        .collection("usernotes")
        .doc(note.createdTime.toIso8601String())
        .update({
      "Title": note.title.toString(),
      "content": note.content.toString(),
    });

    print("Data updated successfully");
  }

  deleteNoteFirestore(Note note) async {
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(current_user!.email.toString())
        .collection("usernotes")
        .doc(note.createdTime.toIso8601String())
        .delete()
        .then((_) {
      print("Delete SucessfULLY");
    });
  }
}
