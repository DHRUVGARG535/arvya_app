import 'dart:async';
import 'package:arvya_app/data/services/analytics_provider.dart';
import 'package:arvya_app/features/journal/screens/journal_screen.dart';
import 'package:arvya_app/features/player/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../data/models/ambience_model.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final AmbienceModel ambience;

  const PlayerScreen({super.key, required this.ambience});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer player;
  bool _sessionStarted = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  late int _totalSeconds;

  StreamSubscription? _positionSub;
  StreamSubscription? _playerStateSub;

  @override
  void initState() {
    super.initState();

    player = ref.read(audioPlayerProvider);

    // ✅ Resume previous position instantly

    _totalSeconds = widget.ambience.duration;

    // ✅ Sync mini player state
    Future.microtask(() {
      ref.read(sessionActiveProvider.notifier).state = true;
      ref.read(activeAmbienceProvider.notifier).state = widget.ambience;
    });

    _initAnimation();
    _initPlayer();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Future<void> _initPlayer() async {
    try {
      final currentAmbience = ref.read(activeAmbienceProvider);

      // ✅ Load only if different audio
      if (currentAmbience?.audio != widget.ambience.audio) {
        await player.setAsset(widget.ambience.audio.trim());
        await player.setLoopMode(LoopMode.one);

        await player.seek(Duration.zero);
      }

      // ✅ ALWAYS listen
      _positionSub = player.positionStream.listen((position) {
        final sec = position.inSeconds;

        if (!mounted) return;

        ref.read(currentSecondsProvider.notifier).state = sec;

        if (sec >= _totalSeconds) {
          _completeSession();
        }
      });

      _playerStateSub = player.playerStateStream.listen((state) {
        if (!mounted) return;
        ref.read(isPlayingProvider.notifier).state = state.playing;
      });
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  void _completeSession() {
    player.stop();

    ref.read(sessionActiveProvider.notifier).state = false;
    ref.read(activeAmbienceProvider.notifier).state = null;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => JournalScreen(ambienceTitle: widget.ambience.title),
      ),
    );
    ref
        .read(analyticsProvider)
        .logEvent("session_end", data: {"title": widget.ambience.title});
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSeconds = ref.watch(currentSecondsProvider);
    final isPlaying = ref.watch(isPlayingProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.ambience.title)),
      body: Stack(
        children: [
          // 🌈 Animated Background
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: _animation.value,
                    colors: [Colors.blue.withOpacity(0.3), Colors.black],
                  ),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Spacer(),

                // ⏱ TIMER
                Text(
                  "${(currentSeconds ~/ 60)}:${(currentSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 36, color: Colors.white),
                ),

                const SizedBox(height: 20),

                // 🎚 SLIDER
                Slider(
                  value: currentSeconds.clamp(0, _totalSeconds).toDouble(),
                  max: _totalSeconds.toDouble(),
                  onChanged: (value) {
                    player.seek(Duration(seconds: value.toInt()));
                  },
                ),

                const SizedBox(height: 20),

                // ▶️ PLAY / PAUSE
                IconButton(
                  iconSize: 70,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (player.playing) {
                      player.pause();
                    } else {
                      player.play();

                      //logging
                      if (!_sessionStarted) {
                        _sessionStarted = true;

                        ref
                            .read(analyticsProvider)
                            .logEvent(
                              "session_start",
                              data: {
                                "title": widget.ambience.title,
                                "duration": widget.ambience.duration,
                              },
                            );
                      }
                    }
                  },
                ),

                const Spacer(),

                // ❌ END SESSION
                ElevatedButton(
                  onPressed: _showEndDialog,
                  child: const Text("End Session"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("End Session?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _completeSession();
            },
            child: const Text("End"),
          ),
        ],
      ),
    );
  }
}
