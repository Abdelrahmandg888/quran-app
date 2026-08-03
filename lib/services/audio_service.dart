import 'package:just_audio/just_audio.dart';

class AudioServiceHandler {
  static final AudioServiceHandler _instance = AudioServiceHandler._internal();
  factory AudioServiceHandler() => _instance;

  final AudioPlayer _player = AudioPlayer();

  AudioServiceHandler._internal();

  AudioPlayer get player => _player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;

  Future<void> playUrl(String url, {String? title, String? artist}) async {
    try {
      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> playFilePath(String filePath) async {
    try {
      await _player.stop();
      await _player.setFilePath(filePath);
      await _player.play();
    } catch (e) {
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
