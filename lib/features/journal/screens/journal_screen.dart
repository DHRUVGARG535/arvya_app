import 'package:arvya_app/data/repositories/journal_respistory.dart';
import 'package:arvya_app/data/services/analytics_provider.dart';
import 'package:arvya_app/features/journal/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/journal_model.dart';
import 'dart:math';

class JournalScreen extends ConsumerStatefulWidget {
  final String ambienceTitle;

  const JournalScreen({super.key, required this.ambienceTitle});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final TextEditingController controller = TextEditingController();
  String? selectedMood;

  final moods = ["Calm", "Grounded", "Energized", "Sleepy"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reflection"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: "Journal History",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "What is gently present with you right now?",
                style: TextStyle(fontSize: 18),
              ),
        
              const SizedBox(height: 20),
        
              TextField(
                controller: controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Write your thoughts...",
                  border: OutlineInputBorder(),
                ),
              ),
        
              const SizedBox(height: 20),
        
              Wrap(
                spacing: 8,
                children: moods.map((mood) {
                  return ChoiceChip(
                    label: Text(mood),
                    selected: selectedMood == mood,
                    onSelected: (_) {
                      setState(() {
                        selectedMood = mood;
                      });
                    },
                  );
                }).toList(),
              ),
        
        
              ElevatedButton(onPressed: _saveJournal, child: const Text("Save")),
            ],
          ),
        ),
      ),
    );
  }

  void _saveJournal() async {
    if (selectedMood == null || controller.text.isEmpty) return;

    final journal = JournalModel(
      id: Random().nextInt(999999).toString(),
      ambienceTitle: widget.ambienceTitle,
      mood: selectedMood!,
      text: controller.text,
      createdAt: DateTime.now(),
    );

    await ref.read(journalRepositoryProvider).saveJournal(journal);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HistoryScreen()),
    );
    ref
        .read(analyticsProvider)
        .logEvent(
          "journal_saved",
          data: {"mood": selectedMood, "text_length": controller.text.length},
        );
  }
}
