
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/models/ambience_model.dart';
import '../../../data/repositories/ambience_repository.dart';

final ambienceRepositoryProvider = Provider((ref) {
  return AmbienceRepository();
});

final ambienceListProvider = FutureProvider<List<AmbienceModel>>((ref) async {
  final repo = ref.watch(ambienceRepositoryProvider);
  return repo.loadAmbiences();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedTagProvider = StateProvider<String?>((ref) => null);

final filteredAmbienceProvider =
    Provider<List<AmbienceModel>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final selectedTag = ref.watch(selectedTagProvider);
  final asyncData = ref.watch(ambienceListProvider);

  return asyncData.maybeWhen(
    data: (list) {
      return list.where((item) {
        final matchesSearch =
            item.title.toLowerCase().contains(query.toLowerCase());

        final matchesTag =
            selectedTag == null || item.tag == selectedTag;

        return matchesSearch && matchesTag;
      }).toList();
    },
    orElse: () => [],
  );
});