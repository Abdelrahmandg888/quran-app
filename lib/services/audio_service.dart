import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioServiceHandler {
  static final AudioServiceHandler _instance = AudioServiceHandler._internal();
  factory AudioServiceHandler() => _instance;

  final AudioPlayer _player = AudioPlayer();

  AudioServiceHandler._internal();

  AudioPlayer get player => _player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;

  Future<void> playUrl(String url, {String? title, String? artist, String? mediaId}) async {
    try {
      final cleanUrl = url.trim();
      final uri = Uri.parse(cleanUrl);
      final mediaItem = MediaItem(
        id: mediaId ?? cleanUrl,
        album: artist ?? 'القرآن الكريم',
        title: title ?? 'تلاوة',
        artist: artist ?? '',
      );
      final audioSource = AudioSource.uri(uri, tag: mediaItem);
      await _player.stop();
      await _player.setAudioSource(audioSource);
      await _player.play();
    } catch (e) {
      debugPrint('AudioServiceHandler playUrl error: $e');
      rethrow;
    }
  }

  Future<void> playFilePath(String filePath, {String? title, String? artist, String? mediaId}) async {
    try {
      final mediaItem = MediaItem(
        id: mediaId ?? filePath,
        album: artist ?? 'القرآن الكريم',
        title: title ?? 'تلاوة محملة',
        artist: artist ?? '',
      );
      final audioSource = AudioSource.file(filePath, tag: mediaItem);
      await _player.stop();
      await _player.setAudioSource(audioSource);
      await _player.play();
    } catch (e) {
      debugPrint('AudioServiceHandler playFilePath error: $e');
      rethrow;
    }
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);
  Future<void> setLoopMode(LoopMode loopMode) => _player.setLoopMode(loopMode);

  void dispose() {
    _player.dispose();
  }
}
