import 'package:flutter/material.dart';
import 'package:jot_notes/Tabs/note_form.dart';
import 'package:jot_notes/home_page.dart';
import 'package:jot_notes/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: NoteAppTheme.lightTheme, // Specify the light theme
      darkTheme: NoteAppTheme.darkTheme, // Specify the dark theme
      themeMode: ThemeMode.system, // Use system theme mode (light/dark)
      // home: HomePage(),r
      initialRoute: "/",
      routes: {
        "/":(context) => HomePage(),
        "addnote":(context) => AddNoteScreen(),

      },
    );
  }
}
