import 'package:arvya_app/features/player/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/player/screeens/player_screen.dart';

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(sessionActiveProvider);
    final ambience = ref.watch(activeAmbienceProvider);
    final isPlaying = ref.watch(isPlayingProvider);
    final position = ref.watch(positionStreamProvider);

    if (!isActive || ambience == null) {
      return const SizedBox.shrink();
    }

    final player = ref.read(audioPlayerProvider);

    return position.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (seconds) {
        final totalSeconds = ambience.duration;

        final progress = totalSeconds == 0
            ? 0.0
            : (seconds.toDouble() / totalSeconds.toDouble()).clamp(0.0, 1.0);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlayerScreen(ambience: ambience),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      // 🎵 TITLE
                      Expanded(
                        child: Text(
                          ambience.title,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // ▶️ PLAY / PAUSE
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ref.read(isPlayingProvider.notifier).state = !ref
                              .read(isPlayingProvider.notifier)
                              .state;
                          if (player.playing) {
                            player.pause();
                          } else {
                            player.play();
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // 📊 PROGRESS BAR
                LinearProgressIndicator(
                  value: progress.isNaN ? 0 : progress,
                  minHeight: 3,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
