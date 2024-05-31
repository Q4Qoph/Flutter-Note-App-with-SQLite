import 'package:flutter/material.dart';
import 'package:jot_notes/db/database_helper.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> { 
  final dbHelper = DatabaseHelper();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _saving = false;
  TextStyle _textStyle = TextStyle();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        actions: [
          IconButton(
            onPressed: _saving
                ? null
                : () async {
                    final title = _titleController.text.trim();
                    final body = _noteController.text.trim();
                    if (title.isNotEmpty && body.isNotEmpty) {
                      setState(() {
                        _saving = true;
                      });

                      try {
                        await dbHelper.insertNote(
                          title: title,
                          body: body,
                          creationDate: DateTime.now(),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        print('Error saving note: $e');
                      } finally {
                        setState(() {
                          _saving = false;
                        });
                      }
                    } else {
                      // Show an error message or handle the empty title/note case
                    }
                  },
            icon: _saving
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.green,
                  scaffoldBackgroundColor: Colors.grey[200],
                  appBarTheme: AppBarTheme(
                    color: Colors.black,
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: TextField(
                        controller: _noteController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          labelText: 'Note',
                          alignLabelWithHint: true,
                        ),
                        style: _textStyle,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
