import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/download_service.dart';
import '../providers/download_provider.dart';
import '../providers/audio_provider.dart';
import '../models/reciter.dart';
import '../models/surah.dart';

class DownloadTile extends StatelessWidget {
  final DownloadedItem item;

  const DownloadTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sizeMb = (item.fileSize / (1024 * 1024)).toStringAsFixed(1);

    return Consumer2<DownloadProvider, AudioProvider>(
      builder: (context, downloadProvider, audioProvider, child) {
        final isPlaying = audioProvider.currentItem?.localPath == item.localPath &&
            audioProvider.isPlaying;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 0,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.offline_pin_rounded,
                color: colorScheme.secondary,
                size: 24,
              ),
            ),
            title: Text(
              'سورة ${item.surahName}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '${item.reciterName} • $sizeMb ميجابايت',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: colorScheme.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    final dummyReciter = Reciter(
                      id: item.reciterId,
                      name: item.reciterName,
                      letter: item.reciterName.isNotEmpty ? item.reciterName[0] : '',
                      moshaf: [],
                    );
                    final dummyMoshaf = Moshaf(
                      id: item.moshafId,
                      name: item.moshafName,
                      rewayaId: 1,
                      server: '',
                      surahTotal: 114,
                      surahList: '',
                    );
                    final dummySurah = Surah(
                      id: item.surahId,
                      name: item.surahName,
                      startPage: 1,
                      endPage: 1,
                      isMakki: true,
                    );

                    audioProvider.playSurah(
                      reciter: dummyReciter,
                      moshaf: dummyMoshaf,
                      surah: dummySurah,
                      playlistSurahs: [dummySurah],
                      localFilePath: item.localPath,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                  onPressed: () {
                    downloadProvider.deleteDownload(item);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
