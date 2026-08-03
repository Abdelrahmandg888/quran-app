import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reciters_provider.dart';
import '../widgets/reciter_card.dart';
import '../widgets/shimmer_loading.dart';
import 'reciter_detail_screen.dart';

class RecitersScreen extends StatelessWidget {
  const RecitersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<RecitersProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('القراء'),
          ),
          body: Column(
            children: [
              // Search Input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  onChanged: provider.search,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن قارئ...',
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

              // Content Area
              Expanded(
                child: provider.isLoading
                    ? const ShimmerListLoading()
                    : provider.error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  size: 48,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  provider.error!,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: provider.loadData,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          )
                        : provider.reciters.isEmpty
                            ? Center(
                                child: Text(
                                  'لا يوجد قراء يطابقون بحثك',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: provider.loadData,
                                child: ListView.builder(
                                  itemCount: provider.reciters.length,
                                  padding: const EdgeInsets.only(bottom: 80),
                                  itemBuilder: (context, index) {
                                    final reciter = provider.reciters[index];
                                    return ReciterCard(
                                      reciter: reciter,
                                      onTap: () {
                                        provider.selectReciter(reciter);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const ReciterDetailScreen(),
                                          ),
                                        );
                                      },
                                    );
                                  },
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
