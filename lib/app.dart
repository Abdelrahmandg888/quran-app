import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/reciters_provider.dart';
import 'providers/radio_provider.dart';
import 'providers/download_provider.dart';
import 'screens/home_screen.dart';

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => RecitersProvider()),
        ChangeNotifierProvider(create: (_) => RadioProvider()),
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'القرآن الكريم',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const Directionality(
              textDirection: TextDirection.rtl,
              child: HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
