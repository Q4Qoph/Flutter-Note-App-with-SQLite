// import 'package:flutter/material.dart';
// import 'package:jot_notes/db/database_helper.dart';
// import 'package:jot_notes/note_model.dart';

// class CreateNote extends StatefulWidget {
//   const CreateNote({super.key, required this.onNewNoteCreated});

//   final Function(Note) onNewNoteCreated;

//   @override
//   State<CreateNote> createState() => _CreateNoteState();
// }

// class _CreateNoteState extends State<CreateNote> {
//   final titleController = TextEditingController();
//   final bodyController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   List<Note> _notes = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loadNotes();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     titleController.dispose();
//     bodyController.dispose();
//     DatabaseHelper.instance.closeDatabase();
//     super.dispose();
//   }

//   Future<void> _loadNotes() async {
//     final notes = await DatabaseHelper.instance.getNotes();
//     setState(() {
//       _notes = notes;
//     });
//   }

//   Future<void> _addNote() async {
//     if (_formKey.currentState!.validate()) {
//       final note = Note(
//         id: DateTime.now().microsecondsSinceEpoch,
//         title: titleController.text,
//         body: bodyController.text,
//       );
//       await DatabaseHelper.instance.insert(note);
//       _resetForm();
//       _loadNotes();
//     }
//   }

//   void _resetForm() {
//     titleController.clear();
//     bodyController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Note'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: titleController,
//               style: TextStyle(
//                 fontSize: 28,
//               ),
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Title",
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'enter title';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             TextFormField(
//               controller: bodyController,
//               style: const TextStyle(fontSize: 18),
//               decoration: InputDecoration(
//                   border: InputBorder.none, hintText: "Jot It Down"),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (titleController.text.isEmpty) {
//             return;
//           }
//           if (bodyController.text.isEmpty) {
//             return;
//           }
//           final notes = Note(
//             id: DateTime.now().microsecondsSinceEpoch,
//             title: titleController.text,
//             body: bodyController.text,
//           );
//           widget.onNewNoteCreated(notes);
//           _addNote();
//           Navigator.of(context).pop();
//         },
//         child: const Icon(Icons.save),
//       ),
//     );
//   }
// }
