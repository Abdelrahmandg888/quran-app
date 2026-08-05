import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_service.dart';
import '../models/reciter.dart';
import '../models/surah.dart';
import '../models/radio_station.dart';

enum AudioItemType { surah, radio }

class PlayableItem {
  final AudioItemType type;
  final String title;
  final String subtitle;
  final String audioUrl;
  final String? localPath;
  final Reciter? reciter;
  final Moshaf? moshaf;
  final Surah? surah;
  final RadioStation? radio;

  PlayableItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.audioUrl,
    this.localPath,
    this.reciter,
    this.moshaf,
    this.surah,
    this.radio,
  });
}

class AudioProvider extends ChangeNotifier {
  final AudioServiceHandler _handler = AudioServiceHandler();

  PlayableItem? _currentItem;
  PlayableItem? get currentItem => _currentItem;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isBuffering = false;
  bool get isBuffering => _isBuffering;

  Duration _position = Duration.zero;
  Duration get position => _position;

  Duration _duration = Duration.zero;
  Duration get duration => _duration;

  double _speed = 1.0;
  double get speed => _speed;

  LoopMode _loopMode = LoopMode.off;
  LoopMode get loopMode => _loopMode;

  Timer? _sleepTimer;
  int? _sleepTimerMinutes;
  int? get sleepTimerMinutes => _sleepTimerMinutes;

  List<Surah> _playlistSurahs = [];
  int _currentSurahIndex = -1;

  AudioProvider() {
    _initListeners();
  }

  void _initListeners() {
    _handler.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isBuffering = state.processingState == ProcessingState.buffering ||
          state.processingState == ProcessingState.loading;
      notifyListeners();
    });

    _handler.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _handler.durationStream.listen((dur) {
      if (dur != null) {
        _duration = dur;
        notifyListeners();
      }
    });
  }

  Future<void> playSurah({
    required Reciter reciter,
    required Moshaf moshaf,
    required Surah surah,
    required List<Surah> playlistSurahs,
    String? localFilePath,
  }) async {
    final title = 'سورة ${surah.name}';
    final subtitle = '${reciter.name} (${moshaf.name})';
    final audioUrl = moshaf.getAudioUrl(surah.id);

    _playlistSurahs = playlistSurahs;
    _currentSurahIndex = playlistSurahs.indexWhere((s) => s.id == surah.id);

    _currentItem = PlayableItem(
      type: AudioItemType.surah,
      title: title,
      subtitle: subtitle,
      audioUrl: audioUrl,
      localPath: localFilePath,
      reciter: reciter,
      moshaf: moshaf,
      surah: surah,
    );

    notifyListeners();

    try {
      if (localFilePath != null && localFilePath.isNotEmpty) {
        await _handler.playFilePath(
          localFilePath,
          title: title,
          artist: subtitle,
          mediaId: localFilePath,
        );
      } else {
        await _handler.playUrl(
          audioUrl,
          title: title,
          artist: subtitle,
          mediaId: audioUrl,
        );
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> playRadio(RadioStation radio) async {
    _playlistSurahs = [];
    _currentSurahIndex = -1;

    _currentItem = PlayableItem(
      type: AudioItemType.radio,
      title: radio.name,
      subtitle: 'إذاعة القرآن الكريم',
      audioUrl: radio.url,
      radio: radio,
    );

    notifyListeners();

    try {
      await _handler.playUrl(
        radio.url,
        title: radio.name,
        artist: 'إذاعة مباشر',
        mediaId: radio.url,
      );
    } catch (e) {
      debugPrint('Error playing radio: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _handler.pause();
    } else {
      await _handler.resume();
    }
  }

  Future<void> seek(Duration pos) async {
    await _handler.seek(pos);
  }

  Future<void> seekForward(int seconds) async {
    final target = _position + Duration(seconds: seconds);
    await _handler.seek(target < _duration ? target : _duration);
  }

  Future<void> seekBackward(int seconds) async {
    final target = _position - Duration(seconds: seconds);
    await _handler.seek(target > Duration.zero ? target : Duration.zero);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _speed = speed;
    await _handler.setSpeed(speed);
    notifyListeners();
  }

  Future<void> toggleLoopMode() async {
    if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.one;
    } else if (_loopMode == LoopMode.one) {
      _loopMode = LoopMode.all;
    } else {
      _loopMode = LoopMode.off;
    }
    await _handler.setLoopMode(_loopMode);
    notifyListeners();
  }

  void setSleepTimer(int? minutes) {
    _sleepTimer?.cancel();
    _sleepTimerMinutes = minutes;

    if (minutes != null && minutes > 0) {
      _sleepTimer = Timer(Duration(minutes: minutes), () {
        _handler.pause();
        _sleepTimerMinutes = null;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  bool get hasNext =>
      _currentItem?.type == AudioItemType.surah &&
      _currentSurahIndex >= 0 &&
      _currentSurahIndex < _playlistSurahs.length - 1;

  bool get hasPrevious =>
      _currentItem?.type == AudioItemType.surah &&
      _currentSurahIndex > 0;

  Future<void> playNext() async {
    if (hasNext && _currentItem != null) {
      final nextSurah = _playlistSurahs[_currentSurahIndex + 1];
      await playSurah(
        reciter: _currentItem!.reciter!,
        moshaf: _currentItem!.moshaf!,
        surah: nextSurah,
        playlistSurahs: _playlistSurahs,
      );
    }
  }

  Future<void> playPrevious() async {
    if (hasPrevious && _currentItem != null) {
      final prevSurah = _playlistSurahs[_currentSurahIndex - 1];
      await playSurah(
        reciter: _currentItem!.reciter!,
        moshaf: _currentItem!.moshaf!,
        surah: prevSurah,
        playlistSurahs: _playlistSurahs,
      );
    }
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _handler.dispose();
    super.dispose();
  }
}
