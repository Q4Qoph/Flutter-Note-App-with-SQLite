import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jot_notes/Tabs/note_form.dart';
import 'package:jot_notes/db/database_helper.dart';

class JotTab extends StatefulWidget {
  const JotTab({Key? key}) : super(key: key);

  @override
  _JotTabState createState() => _JotTabState();
}

class _JotTabState extends State<JotTab> {
  final dbHelper = DatabaseHelper();
  final TextEditingController _stickyController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _stickyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _stickyController,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write your sticky notes here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: _saving ? null : _saveSticky,
                icon: Icon(Icons.check),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _addNote,
                icon: Icon(Icons.note_add),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add_task),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHelper.getSticky(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> stickys = List<Map<String, dynamic>>.from(snapshot.data ?? []);

                  // Ensure all entries have non-null creation dates for sorting
                  stickys.sort((a, b) {
                    String dateA = a['creation_date'] ?? '';
                    String dateB = b['creation_date'] ?? '';
                    return dateB.compareTo(dateA);
                  });

                  return ListView.builder(
                    itemCount: stickys.length,
                    itemBuilder: (context, index) {
                      final sticky = stickys[index];
                      final color = _getRandomColor();
                      final body = sticky['body'] ?? 'No content';
                      final creationDate = sticky['creation_date'] as String?;
                      return Card(
                        child: ListTile(
                          tileColor: color,
                          title: Text(body),
                          subtitle: Text(
                            creationDate != null
                                ? 'Created on ${_formatCreationDate(creationDate)}'
                                : 'Creation date unknown',
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveSticky() async {
    final sticky = _stickyController.text.trim();
    if (sticky.isNotEmpty) {
      setState(() {
        _saving = true;
      });

      try {
        await dbHelper.insertSticky(body: sticky, creationDate: DateTime.now());
        _stickyController.clear(); // Clear the input field after saving
      } catch (e) {
        print('Error saving note: $e');
      } finally {
        setState(() {
          _saving = false;
        });
      }
    } else {
      // Display an error message if the sticky note is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sticky note cannot be empty')),
      );
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
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }
}
