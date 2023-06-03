import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';

class DatabaseService {
  static const boxName = 'note';

  Future<void> addNote(Note note) async {
    final box = await Hive.openBox(boxName);
    await box.add(note);
  }

  Future<void> editNote(int key, Note note) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, note);
  }

  Future<List<Note>> getNote() async {
    final box = await Hive.openBox(boxName);
    return box.values.toList().cast<Note>();
  }

  Future<void> deleteNote(Note note) async {
    final box = await Hive.openBox(boxName);
    box.delete(note.key);
  }
}
