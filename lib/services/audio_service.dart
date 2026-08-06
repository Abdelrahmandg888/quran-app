import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioServiceHandler {
  static final AudioServiceHandler _instance = AudioServiceHandler._internal();
  factory AudioServiceHandler() => _instance;

  final AudioPlayer _player = AudioPlayer();

  AudioServiceHandler._internal() {
    // Listen for playback errors
    _player.playbackEventStream.listen(
      (event) {
        debugPrint('AudioPlayer event: processingState=${event.processingState}');
      },
      onError: (Object e, StackTrace stackTrace) {
        debugPrint('AudioPlayer playback error: $e');
        debugPrint('Stack trace: $stackTrace');
      },
    );

    // Listen for player state changes for debugging
    _player.playerStateStream.listen((state) {
      debugPrint('AudioPlayer state: playing=${state.playing}, processingState=${state.processingState}');
    });
  }

  AudioPlayer get player => _player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;

  Future<void> playUrl(String url, {String? title, String? artist, String? mediaId}) async {
    try {
      final cleanUrl = url.trim();
      debugPrint('AudioServiceHandler.playUrl: $cleanUrl');

      final uri = Uri.parse(cleanUrl);
      debugPrint('AudioServiceHandler: Parsed URI: $uri');

      final mediaItem = MediaItem(
        id: mediaId ?? cleanUrl,
        album: artist ?? 'القرآن الكريم',
        title: title ?? 'تلاوة',
        artist: artist ?? '',
      );

      final audioSource = AudioSource.uri(
        uri,
        tag: mediaItem,
        headers: const {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 11; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
          'Accept': '*/*',
        },
      );

      // Stop any currently playing audio first
      await _player.stop();

      // Set the audio source and wait for it to load
      final duration = await _player.setAudioSource(
        audioSource,
        preload: true,
      );
      debugPrint('AudioServiceHandler: Source loaded, duration=$duration');

      // Only play if source loaded successfully
      if (duration != null || _player.processingState != ProcessingState.idle) {
        await _player.play();
        debugPrint('AudioServiceHandler: play() called successfully');
      } else {
        debugPrint('AudioServiceHandler: Source failed to load (duration is null and state is idle)');
        // Try playing anyway - some streams don't report duration upfront
        await _player.play();
      }
    } catch (e, stackTrace) {
      debugPrint('AudioServiceHandler playUrl error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> playFilePath(String filePath, {String? title, String? artist, String? mediaId}) async {
    try {
      debugPrint('AudioServiceHandler.playFilePath: $filePath');

      final mediaItem = MediaItem(
        id: mediaId ?? filePath,
        album: artist ?? 'القرآن الكريم',
        title: title ?? 'تلاوة محملة',
        artist: artist ?? '',
      );

      final audioSource = AudioSource.file(filePath, tag: mediaItem);

      // Stop any currently playing audio first
      await _player.stop();

      final duration = await _player.setAudioSource(audioSource, preload: true);
      debugPrint('AudioServiceHandler: File source loaded, duration=$duration');

      await _player.play();
    } catch (e, stackTrace) {
      debugPrint('AudioServiceHandler playFilePath error: $e');
      debugPrint('Stack trace: $stackTrace');
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
