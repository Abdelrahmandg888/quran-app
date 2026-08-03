import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/theme_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('الإعدادات والمظاهر'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Theme Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text(
                  'اختر ثيم التطبيق (5 مظاهر مخصصة)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 5 Themes Cards List
              ...List.generate(AppThemeMode.values.length, (index) {
                final mode = AppThemeMode.values[index];
                final isSelected = themeProvider.currentThemeMode == mode;
                final themeName = ThemeConstants.themeNamesAr[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 0,
                  color: isSelected
                      ? colorScheme.primaryContainer.withOpacity(0.4)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.12),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _getThemeColor(mode),
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                    title: Text(
                      themeName,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      _getThemeDescription(mode),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    onTap: () {
                      themeProvider.setThemeMode(mode);
                    },
                  ),
                );
              }),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // App Info Card
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 40,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'القرآن الكريم MP3',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الإصدار 1.0.0 • مدعوم من MP3Quran.net V3 API',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
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

  Color _getThemeColor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.emeraldIslamic:
        return const Color(0xFF0F5132);
      case AppThemeMode.midnightSanctuary:
        return const Color(0xFF0B132B);
      case AppThemeMode.desertSand:
        return const Color(0xFFB35C41);
      case AppThemeMode.slateEther:
        return const Color(0xFF2A4365);
      case AppThemeMode.obsidianPrecision:
        return const Color(0xFF1F1F1F);
    }
  }

  String _getThemeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.emeraldIslamic:
        return 'تصميم إسلامي باللون الزمردي والذهبي الفاخر';
      case AppThemeMode.midnightSanctuary:
        return 'ثيم ليلي داكن بألوان أزرق الليل واللمسات الذهبية';
      case AppThemeMode.desertSand:
        return 'ألوان دافئة مستوحاة من رمال الصحراء والخط العربي';
      case AppThemeMode.slateEther:
        return 'تصميم عصري بسيط بألوان الرمادي والأزرق الصافي';
      case AppThemeMode.obsidianPrecision:
        return 'أسود نقي AMOLED للحفاظ على شاشتك وعينيك';
    }
  }
}
