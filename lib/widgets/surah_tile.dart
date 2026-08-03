import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/surah.dart';
import '../models/reciter.dart';
import '../providers/audio_provider.dart';
import '../providers/download_provider.dart';

class SurahTile extends StatelessWidget {
  final Surah surah;
  final Reciter reciter;
  final Moshaf moshaf;
  final List<Surah> playlistSurahs;

  const SurahTile({
    super.key,
    required this.surah,
    required this.reciter,
    required this.moshaf,
    required this.playlistSurahs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer2<AudioProvider, DownloadProvider>(
      builder: (context, audioProvider, downloadProvider, child) {
        final isCurrentItem = audioProvider.currentItem?.surah?.id == surah.id &&
            audioProvider.currentItem?.reciter?.id == reciter.id;
        final isPlayingCurrent = isCurrentItem && audioProvider.isPlaying;

        final isDownloaded = downloadProvider.isDownloaded(reciter.id, moshaf.id, surah.id);
        final isDownloading = downloadProvider.isDownloading(reciter.id, moshaf.id, surah.id);
        final downloadProgress = downloadProvider.getDownloadProgress(reciter.id, moshaf.id, surah.id);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: 0,
          color: isCurrentItem
              ? colorScheme.primaryContainer.withOpacity(0.4)
              : null,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCurrentItem
                    ? colorScheme.primary
                    : colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${surah.id}',
                  style: TextStyle(
                    color: isCurrentItem ? colorScheme.onPrimary : colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            title: Text(
              'سورة ${surah.name}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isCurrentItem ? colorScheme.primary : null,
              ),
            ),
            subtitle: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    surah.typeName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'الصفحات: ${surah.startPage}-${surah.endPage}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Download button or progress
                if (isDownloading)
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: downloadProgress,
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, size: 14),
                          onPressed: () {
                            downloadProvider.cancelDownload(reciter.id, moshaf.id, surah.id);
                          },
                        ),
                      ],
                    ),
                  )
                else if (isDownloaded)
                  IconButton(
                    icon: Icon(
                      Icons.check_circle_rounded,
                      color: colorScheme.secondary,
                      size: 24,
                    ),
                    onPressed: () {
                      final item = downloadProvider.getDownloadedItem(reciter.id, moshaf.id, surah.id);
                      if (item != null) {
                        downloadProvider.deleteDownload(item);
                      }
                    },
                    tooltip: 'محفوظة (اضغط للحذف)',
                  )
                else
                  IconButton(
                    icon: Icon(
                      Icons.download_rounded,
                      color: colorScheme.onSurface.withOpacity(0.6),
                      size: 22,
                    ),
                    onPressed: () {
                      final audioUrl = moshaf.getAudioUrl(surah.id);
                      downloadProvider.startDownload(
                        audioUrl: audioUrl,
                        reciterId: reciter.id,
                        reciterName: reciter.name,
                        moshafId: moshaf.id,
                        moshafName: moshaf.name,
                        surahId: surah.id,
                        surahName: surah.name,
                      );
                    },
                    tooltip: 'تحميل للاستماع بدون إنترنت',
                  ),
                
                const SizedBox(width: 4),

                // Play / Pause button
                IconButton(
                  icon: Icon(
                    isPlayingCurrent
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: colorScheme.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    final downloadedItem = downloadProvider.getDownloadedItem(
                      reciter.id,
                      moshaf.id,
                      surah.id,
                    );
                    audioProvider.playSurah(
                      reciter: reciter,
                      moshaf: moshaf,
                      surah: surah,
                      playlistSurahs: playlistSurahs,
                      localFilePath: downloadedItem?.localPath,
                    );
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
