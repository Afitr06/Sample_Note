import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/db/database_service.dart';
import 'package:simple_note/extension/my_date.dart';
import 'package:simple_note/utils/app_route.dart';

import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simple Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(DatabaseService.boxName).listenable(),
        builder: (context, value, _) {
          if (value.isEmpty) {
            return const Center(
              child: Text("tidak ada data"),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, index) {
                Note tempNote = value.getAt(index);
                return Dismissible(
                  key: Key(value.values.toList()[index].key.toString()),
                  child: NoteCard(
                    note: tempNote,
                  ),
                  onDismissed: (_) async {
                    await DatabaseService().deleteNote(tempNote);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("data telah dihapus"),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 8,
                );
              },
              itemCount: value.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            GoRouter.of(context).pushNamed('add-Note').then((_) {
              setState(() {});
            });
          },
          child: const Icon(
            Icons.note_add,
          )),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          GoRouter.of(context).pushNamed(
            AppRoutes.editNote,
            extra: note,
          );
        },
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          note.desc,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          'dibuat pada \n ${note.createAt.formatDate()}',
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
