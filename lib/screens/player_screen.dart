import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final item = audioProvider.currentItem;

        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('لا يتم تشغيل أي مقطع الآن')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('مشغل القرآن'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  audioProvider.sleepTimerMinutes != null
                      ? Icons.timer_rounded
                      : Icons.timer_outlined,
                  color: audioProvider.sleepTimerMinutes != null
                      ? colorScheme.secondary
                      : colorScheme.onSurface,
                ),
                onPressed: () => _showSleepTimerDialog(context, audioProvider),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const Spacer(),

                // Artwork / Calligraphy Box
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.2),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.type == AudioItemType.radio
                              ? Icons.radio_rounded
                              : Icons.menu_book_rounded,
                          size: 72,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'القرآن الكريم',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Title & Subtitle
                Text(
                  item.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  item.subtitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 32),

                // Slider / Timeline (for Surahs)
                if (item.type == AudioItemType.surah) ...[
                  Slider(
                    value: audioProvider.position.inMilliseconds
                        .clamp(0, audioProvider.duration.inMilliseconds.clamp(1, double.maxFinite.toInt()))
                        .toDouble(),
                    max: audioProvider.duration.inMilliseconds > 0
                        ? audioProvider.duration.inMilliseconds.toDouble()
                        : 1.0,
                    onChanged: (val) {
                      audioProvider.seek(Duration(milliseconds: val.toInt()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(audioProvider.position),
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          _formatDuration(audioProvider.duration),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'بث مباشر حي',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 24),

                // Main Transport Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      iconSize: 28,
                      icon: const Icon(Icons.replay_10_rounded),
                      onPressed: () => audioProvider.seekBackward(10),
                    ),
                    IconButton(
                      iconSize: 36,
                      icon: const Icon(Icons.skip_previous_rounded),
                      onPressed: audioProvider.hasPrevious ? audioProvider.playPrevious : null,
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: audioProvider.isBuffering
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : IconButton(
                              iconSize: 36,
                              color: colorScheme.onPrimary,
                              icon: Icon(
                                audioProvider.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                              onPressed: audioProvider.togglePlayPause,
                            ),
                    ),
                    IconButton(
                      iconSize: 36,
                      icon: const Icon(Icons.skip_next_rounded),
                      onPressed: audioProvider.hasNext ? audioProvider.playNext : null,
                    ),
                    IconButton(
                      iconSize: 28,
                      icon: const Icon(Icons.forward_10_rounded),
                      onPressed: () => audioProvider.seekForward(10),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Additional Features Controls Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Speed selector
                    TextButton.icon(
                      onPressed: () => _showSpeedMenu(context, audioProvider),
                      icon: const Icon(Icons.speed_rounded, size: 20),
                      label: Text('${audioProvider.speed}x'),
                    ),

                    // Loop mode toggle
                    IconButton(
                      icon: Icon(
                        audioProvider.loopMode.name == 'one'
                            ? Icons.repeat_one_rounded
                            : Icons.repeat_rounded,
                        color: audioProvider.loopMode.name != 'off'
                            ? colorScheme.primary
                            : colorScheme.onSurface.withOpacity(0.4),
                      ),
                      onPressed: audioProvider.toggleLoopMode,
                    ),
                  ],
                ),

                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSleepTimerDialog(BuildContext context, AudioProvider audioProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مؤقت النوم',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('إيقاف المؤقت'),
                trailing: audioProvider.sleepTimerMinutes == null ? const Icon(Icons.check) : null,
                onTap: () {
                  audioProvider.setSleepTimer(null);
                  Navigator.pop(ctx);
                },
              ),
              ...[15, 30, 45, 60].map((mins) {
                final isSelected = audioProvider.sleepTimerMinutes == mins;
                return ListTile(
                  title: Text('$mins دقيقة'),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    audioProvider.setSleepTimer(mins);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSpeedMenu(BuildContext context, AudioProvider audioProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'سرعة التشغيل',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...[0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
                final isSelected = audioProvider.speed == speed;
                return ListTile(
                  title: Text('${speed}x'),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    audioProvider.setPlaybackSpeed(speed);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
