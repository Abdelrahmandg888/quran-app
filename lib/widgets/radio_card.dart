import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/radio_station.dart';
import '../providers/audio_provider.dart';

class RadioCard extends StatelessWidget {
  final RadioStation radio;

  const RadioCard({
    super.key,
    required this.radio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final isCurrentRadio = audioProvider.currentItem?.type == AudioItemType.radio &&
            audioProvider.currentItem?.radio?.id == radio.id;
        final isPlaying = isCurrentRadio && audioProvider.isPlaying;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 0,
          color: isCurrentRadio ? colorScheme.primaryContainer.withOpacity(0.4) : null,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCurrentRadio ? colorScheme.primary : colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.radio_rounded,
                color: isCurrentRadio ? colorScheme.onPrimary : colorScheme.primary,
                size: 26,
              ),
            ),
            title: Text(
              radio.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isCurrentRadio ? colorScheme.primary : null,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isPlaying ? Colors.redAccent : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'بث مباشر',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isPlaying ? Colors.redAccent : colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded,
                color: colorScheme.primary,
                size: 36,
              ),
              onPressed: () {
                if (isCurrentRadio) {
                  audioProvider.togglePlayPause();
                } else {
                  audioProvider.playRadio(radio);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
