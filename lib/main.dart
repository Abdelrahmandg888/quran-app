import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'net.mp3quran.quran.channel.audio',
      androidNotificationChannelName: 'تلاوات القرآن الكريم',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    );
  } catch (e) {
    debugPrint('JustAudioBackground init error: $e');
  }

  runApp(const QuranApp());
}
