import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jot_notes/Tabs/jot_tab.dart';
import 'package:jot_notes/Tabs/notes_tab.dart';
import 'package:jot_notes/db/database_helper.dart';
// import 'package:jot_notes/Tabs/create_note.dart';
// import 'package:jot_notes/note_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late StreamSubscription _dbChangesSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _listenToDbChanges();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dbChangesSubscription.cancel();
    super.dispose();
  }

  void _listenToDbChanges() {
    _dbChangesSubscription = DatabaseHelper().dbChangesStream.listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'JOT'),
            Tab(text: 'NOTES'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            JotTab(),
            NotesTab(),
          ],
        ),
      ),
    );
  }
}
