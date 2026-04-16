import 'package:arvya_app/features/ambience/providers/ambience_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ambienceList = ref.watch(ambienceListProvider);
    final filteredAmbiences = ref.watch(filteredAmbienceProvider);
    final selectedTag = ref.watch(selectedTagProvider);

    final tags = ["Focus", "Calm", "Sleep", "Reset"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ambiences"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search ambiences...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),

          // 🏷 Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: tags.map((tag) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: selectedTag == tag,
                    onSelected: (_) {
                      ref.read(selectedTagProvider.notifier).state =
                          selectedTag == tag ? null : tag;
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // 📦 LIST AREA
          Expanded(
            child: ambienceList.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),

              error: (e, _) =>
                  Center(child: Text("Error: $e")),

              data: (_) {
                // 👉 IMPORTANT: filtered list use karni hai
                if (filteredAmbiences.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No ambiences found",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref.read(selectedTagProvider.notifier).state = null;
                          },
                          child: const Text("Clear Filters"),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredAmbiences.length,
                  itemBuilder: (context, index) {
                    final item = filteredAmbiences[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(item.tag),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                        onTap: () {
                          // 👉 NEXT STEP: navigate to details screen
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}