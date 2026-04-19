import 'package:arvya_app/data/repositories/journal_respistory.dart';
import 'package:arvya_app/features/journal/widgets/journal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalLists = ref.watch(journalListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal History"),
        centerTitle: true,
      ),
      body: journalLists.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text("Error: $e")),

        data: (journals) {
          if (journals.isEmpty) {
            return const Center(
              child: Text(
                "No reflections yet.\nStart a session to begin.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final sorted = journals.reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final item = sorted[index];

              return JournalCard(journal: item);
            },
          );
        },
      ),
    );
  }
}