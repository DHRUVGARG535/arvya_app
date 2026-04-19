import 'package:arvya_app/data/models/journal_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalCard extends StatelessWidget {
  final JournalModel journal;

  const JournalCard({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat("dd MMM, hh:mm a").format(journal.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        // 🧠 Title (ambience)
        title: Text(
          journal.ambienceTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              journal.text.split('\n').first,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),

        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            journal.mood,
            style: const TextStyle(fontSize: 12),
          ),
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JournalDetailScreen(journal: journal),
            ),
          );
        },
      ),
    );
  }
}

class JournalDetailScreen extends StatelessWidget {
  final JournalModel journal;

  const JournalDetailScreen({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat("dd MMM yyyy, hh:mm a").format(journal.createdAt);

    return Scaffold(
      appBar: AppBar(title: const Text("Reflection")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              journal.ambienceTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              formattedDate,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            Chip(label: Text(journal.mood)),

            const SizedBox(height: 20),

            Text(
              journal.text,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}