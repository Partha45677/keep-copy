import 'package:flutter/material.dart';
import 'package:keepnote/NoteShow.dart';
import 'package:keepnote/Services/databaseModel.dart';
import 'package:keepnote/Services/db.dart';
import 'package:keepnote/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController searchController = new TextEditingController();
  List<int> SearchResultsIDs = [];
  List<Note?> SearchResultsNotes = [];
  bool isLoading = false;

  void SearchResults(String query) async {
    SearchResultsNotes.clear();
    setState(() {
      isLoading = true;
    });

    final ResultIds = await NotesDatabase.instance.getNoteString(query);
    List<Note?> SearchResultLocal = [];
    ResultIds.forEach((element) async {
      final SearchNotes = await NotesDatabase.instance.readOneNote(element);
      SearchResultLocal.add(SearchNotes);
      setState(() {
        SearchResultsNotes.add(SearchNotes);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: white.withOpacity(0.1)),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/back');
                        },
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          color: white,
                        )),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if (value.replaceAll(" ", "") == "") {
                          } else {
                            setState(() {
                              SearchResults(value.toLowerCase());
                            });
                          }
                        },
                        cursorColor: white,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Search Your Notes",
                          hintStyle: TextStyle(
                            color: white.withOpacity(0.7),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                NoteSectionSearch()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget NoteSectionSearch() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: StaggeredGridView.countBuilder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: SearchResultsNotes.length,
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
                          note: SearchResultsNotes[index]!,
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
                  SearchResultsNotes[index]!.title,
                  style: TextStyle(color: white, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  SearchResultsNotes[index]!.content.length > 250
                      ? "${SearchResultsNotes[index]!.content.substring(0, 250)}...."
                      : SearchResultsNotes[index]!.content,
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
