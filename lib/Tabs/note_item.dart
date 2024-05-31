import 'package:flutter/material.dart';
import 'package:jot_notes/Tabs/edit_note_screen.dart';

class NoteItemScreen extends StatelessWidget {
  const NoteItemScreen({super.key ,required this.noteTitle, required this.noteContent,required this.onUpdate, });
  final String noteTitle;
  final String noteContent;
  final Function onUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title :Text(noteTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: ()async {
              await _editNote(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText('Title: $noteTitle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(height: 10),
              SelectableText('Note: $noteContent', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _editNote(BuildContext context) async{
    try{
      final updatedNote = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditNoteScreen(
            initialTitle: noteTitle,
            initialContent: noteContent,
            onUpdate: onUpdate, 
          ),
        )
      );
      if (updatedNote != null){
        onUpdate();
      }
    }catch (e){
      print('Error editing note: $e');
    }
  }
}