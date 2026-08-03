import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/radio_provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/radio_card.dart';
import '../widgets/shimmer_loading.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<RadioProvider>(
      builder: (context, radioProvider, child) {
        final featured = radioProvider.featuredRadio;

        return Scaffold(
          appBar: AppBar(
            title: const Text('إذاعات القرآن الكريم'),
          ),
          body: Column(
            children: [
              // Search Input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  onChanged: radioProvider.search,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن إذاعة...',
                    prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.primary.withOpacity(0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              if (radioProvider.isLoading)
                const Expanded(child: ShimmerListLoading())
              else if (radioProvider.error != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                        const SizedBox(height: 12),
                        Text(radioProvider.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: radioProvider.loadRadios,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: radioProvider.loadRadios,
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [
                        // Featured Hero Card
                        if (featured != null && radioProvider.searchQuery.isEmpty) ...[
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.primary.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Consumer<AudioProvider>(
                              builder: (context, audioProvider, child) {
                                final isPlayingFeatured = audioProvider.currentItem?.radio?.id == featured.id &&
                                    audioProvider.isPlaying;

                                return Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.live_tv_rounded, color: Colors.white, size: 12),
                                                SizedBox(width: 4),
                                                Text(
                                                  'مباشر الآن',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            featured.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'إذاعة القرآن الكريم - بث متواصل 24 ساعة',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.85),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 52,
                                      icon: Icon(
                                        isPlayingFeatured
                                            ? Icons.pause_circle_filled_rounded
                                            : Icons.play_circle_fill_rounded,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (isPlayingFeatured) {
                                          audioProvider.togglePlayPause();
                                        } else {
                                          audioProvider.playRadio(featured);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Text(
                              'جميع الإذاعات (${radioProvider.radios.length})',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],

                        ...radioProvider.radios.map((radio) {
                          return RadioCard(radio: radio);
                        }),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
