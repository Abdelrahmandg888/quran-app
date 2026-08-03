import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reciters_provider.dart';
import '../widgets/surah_tile.dart';

class ReciterDetailScreen extends StatelessWidget {
  const ReciterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<RecitersProvider>(
      builder: (context, provider, child) {
        final reciter = provider.selectedReciter;
        final selectedMoshaf = provider.selectedMoshaf;

        if (reciter == null || selectedMoshaf == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('لم يتم اختيار قارئ')),
          );
        }

        final availableSurahs = provider.getAvailableSurahsForSelectedMoshaf();

        return Scaffold(
          appBar: AppBar(
            title: Text(reciter.name),
          ),
          body: Column(
            children: [
              // Header Card with Moshaf selector
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.mic_external_on_rounded,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            reciter.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (reciter.moshaf.length > 1) ...[
                      Text(
                        'اختر الرواية / المصحف:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: reciter.moshaf.map((moshaf) {
                            final isSelected = moshaf.id == selectedMoshaf.id;
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ChoiceChip(
                                label: Text(moshaf.name),
                                selected: isSelected,
                                selectedColor: colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    provider.selectMoshaf(moshaf);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      'المصاحف المتاحة: ${selectedMoshaf.name} • ${availableSurahs.length} سورة',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Surahs List Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'قائمة السور',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${availableSurahs.length} سورة',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Surah List
              Expanded(
                child: availableSurahs.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد سور متاحة لهذا المصحف حالياً',
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: availableSurahs.length,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemBuilder: (context, index) {
                          final surah = availableSurahs[index];
                          return SurahTile(
                            surah: surah,
                            reciter: reciter,
                            moshaf: selectedMoshaf,
                            playlistSurahs: availableSurahs,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
