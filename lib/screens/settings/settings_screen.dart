import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_constants.dart';
import '../../providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentTheme = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Language Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'اللغة',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioListTile<String>(
            title: const Text('العربية'),
            value: 'ar',
            groupValue: currentLocale.languageCode,
            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).state = Locale(value);
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: currentLocale.languageCode,
            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).state = Locale(value);
              }
            },
          ),
          const Divider(),

          // Theme Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'المظهر',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('فاتح'),
            value: ThemeMode.light,
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).state = value;
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('غامق'),
            value: ThemeMode.dark,
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).state = value;
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('تلقائي'),
            value: ThemeMode.system,
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).state = value;
              }
            },
          ),
          const Divider(),

          // About Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'معلومات',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListTile(
            title: const Text('حول التطبيق'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: AppConstants.appName,
                applicationVersion: AppConstants.appVersion,
                applicationLegalese:
                    '© 2026 جميع الحقوق محفوظة - دليلك',
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'دليلك هو تطبيق يساعدك على اكتشاف أفضل المتاجر والخدمات حول بك.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              );
            },
          ),
          ListTile(
            title: const Text('سياسة الخصوصية'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLinkDialog(context, 'سياسة الخصوصية');
            },
          ),
          ListTile(
            title: const Text('الشروط والأحكام'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLinkDialog(context, 'الشروط والأحكام');
            },
          ),
          const Divider(),

          // Actions Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'إجراءات',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListTile(
            title: const Text('قيّم التطبيق'),
            trailing: const Icon(Icons.star_outline),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('شكراً! سيتم نقلك إلى متجر التطبيقات'),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('مشاركة'),
            trailing: const Icon(Icons.share),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم نسخ الرابط إلى الحافظة'),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showLinkDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          'يمكنك قراءة $title من خلال موقعنا الإلكتروني',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
