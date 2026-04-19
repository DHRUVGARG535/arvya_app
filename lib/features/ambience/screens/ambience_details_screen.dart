import 'package:arvya_app/features/player/screeens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/ambience_model.dart';
import 'package:arvya_app/shared/widgets/mini_player_bar.dart';

class AmbienceDetailsScreen extends ConsumerWidget {
  final AmbienceModel ambience;

  const AmbienceDetailsScreen({super.key, required this.ambience});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(ambience.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(20),
                ),
                child: Image.asset(
                  ambience.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 48),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ambience.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Chip(label: Text(ambience.tag)),
                      const SizedBox(width: 10),
                      Text("${ambience.duration ~/ 60} min"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    ambience.description,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    children: ambience.sensory.map((item) {
                      return Chip(label: Text(item));
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayerScreen(ambience: ambience),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Start Session"),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MiniPlayerBar(),
    );
  }
}
