// import 'package:flutter/material.dart';
// import 'package:jot_notes/Tabs/note_view.dart';
// import 'package:jot_notes/note_model.dart';

// class NoteCard extends StatelessWidget {
//   const NoteCard(
//       {super.key,
//       required this.note,
//       required this.onNoteDeleted,
//       required this.index});

//   final Note note;
//   final int index;
//   final Function(int) onNoteDeleted;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => NoteView(
//                 note: note, index: index, onNoteDeleted: onNoteDeleted)));
//       },
//       child: Card(
//         child: Padding(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 note.title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 note.body,
//                 style: const TextStyle(
//                   fontSize: 20,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
