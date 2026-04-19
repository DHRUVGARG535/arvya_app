import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';
import '../models/journal_model.dart';

class JournalRepository {
  static const String boxName = "journals";

  Future<void> saveJournal(JournalModel journal) async {
    final box = await Hive.openBox(boxName);
    await box.put(journal.id, journal.toJson());
  }

  Future<List<JournalModel>> getJournals() async {
    final box = await Hive.openBox(boxName);

    return box.values
        .map((e) => JournalModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

final journalRepositoryProvider = Provider((ref) {
  return JournalRepository();
});

final journalListProvider = FutureProvider<List<JournalModel>>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getJournals();
});