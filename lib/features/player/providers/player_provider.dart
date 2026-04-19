import 'dart:async';
import 'package:arvya_app/data/models/ambience_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:just_audio/just_audio.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final isPlayingProvider = StateProvider<bool>((ref) => false);
final currentSecondsProvider = StateProvider<int>((ref) => 0);
final totalDurationProvider = StateProvider<Duration>((ref) => Duration.zero);

final positionStreamProvider = StreamProvider<int>((ref) {
  final player = ref.watch(audioPlayerProvider);

  return player.positionStream.map((position) => position.inSeconds);
});

final sessionTimerProvider =
    StateNotifierProvider<SessionTimerNotifier, Duration>((ref) {
  return SessionTimerNotifier();
});

final sessionActiveProvider = StateProvider<bool>((ref) => false);
final activeAmbienceProvider = StateProvider<AmbienceModel?>((ref) => null);

class SessionTimerNotifier extends StateNotifier<Duration> {
  SessionTimerNotifier() : super(Duration.zero);

  Timer? _timer;

  void start(Duration total, VoidCallback onComplete) {
    _timer?.cancel();
    state = Duration.zero;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state += const Duration(seconds: 1);

      if (state >= total) {
        timer.cancel();
        onComplete();
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}