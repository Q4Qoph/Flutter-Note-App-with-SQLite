import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jot_notes/Tabs/note_form.dart';
import 'package:jot_notes/Tabs/note_item.dart';
import 'package:jot_notes/db/database_helper.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({
    Key? key,
  }) : super(key: key);

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement your search logic here
              // showSearch(
              //   context: context,
              //   delegate: NoteSearchDelegate(
              //     dbHelper.getNotes(), _openNoteItem
              //   ),
              // );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> notes = snapshot.data?.toList() ?? [];
            notes.sort(
              (a, b) => b['creation_date'].compareTo(a['creation_date']),
            );

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final random = Random();
                final color = Color.fromARGB(
                  255,
                  random.nextInt(256),
                  random.nextInt(256),
                  random.nextInt(256),
                );
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color,
                    child: Text(
                      note['title'][0].toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(note['title']),
                  subtitle: Text(
                    'Created on ${_formatCreationDate(note['creation_date'])}',
                  ),
                  onTap: () => _openNoteItem(note),
                  onLongPress: () {},
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _openNoteItem(Map<String, dynamic> note) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteItemScreen(
            noteTitle: note['title'],
            noteContent: note['body'],
            onUpdate: () => setState(() {}),
          ),
        ),
      );
      if (result != null && result) {
        // If the note was updated, call the onUpdate callback
        setState(() {});
      }
    } catch (e) {
      print('Error opening note item: $e');
    }
  }

  Future<void> _addNote() async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNoteScreen(),
        ),
      );
      setState(() {});
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  String _formatCreationDate(String creationDate) {
    final dateTime = DateTime.parse(creationDate);
    final formattedDate =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    // Limit the length of formatted date string
    final maxLength = 16;
    return formattedDate.length <= maxLength
        ? formattedDate
        : formattedDate.substring(0, maxLength);
  }
}
