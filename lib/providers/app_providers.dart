import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

// Shared Preferences Provider
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Locale Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref);
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this.ref) : super(const Locale('ar')) {
    _loadLocale();
  }

  final Ref ref;

  Future<void> _loadLocale() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final languageCode = prefs.getString(AppConstants.spKeyLanguage) ?? 'ar';
    state = Locale(languageCode);
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(AppConstants.spKeyLanguage, languageCode);
    state = Locale(languageCode);
  }
}

// Theme Mode Provider
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this.ref) : super(ThemeMode.light) {
    _loadTheme();
  }

  final Ref ref;

  Future<void> _loadTheme() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final themeName = prefs.getString(AppConstants.spKeyTheme) ?? 'light';
    state = themeName == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final themeName = mode == ThemeMode.dark ? 'dark' : 'light';
    await prefs.setString(AppConstants.spKeyTheme, themeName);
    state = mode;
  }
}

// App Initialization Provider
final appInitializerProvider = FutureProvider<void>((ref) async {
  // Initialize SharedPreferences
  await ref.read(sharedPreferencesProvider.future);

  // Check if first run
  final prefs = await ref.read(sharedPreferencesProvider.future);
  final isFirstRun =
      prefs.getBool(AppConstants.spKeyFirstRun) ?? true;

  if (isFirstRun) {
    await prefs.setBool(AppConstants.spKeyFirstRun, false);
  }
});

// Is First Run Provider
final isFirstRunProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.read(sharedPreferencesProvider.future);
  return prefs.getBool(AppConstants.spKeyFirstRun) ?? true;
});
