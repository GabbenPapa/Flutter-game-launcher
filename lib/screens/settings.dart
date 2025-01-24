import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:game_launcher/providers/settings_provider.dart';
import 'package:provider/provider.dart';

import '../providers/intro_provider.dart';
import 'launcher_screen.dart';
import '../theme/themes.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';

  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String _selectedLanguage = 'English';
  final Map<String, String> languageMap = {
    'English': 'en',
    'Hungarian': 'hu',
    'German': 'de',
  };

  void setSelectedLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    setSelectedLanguage(
      languageMap.entries
          .firstWhere(
              (entry) => entry.value == languageProvider.currentLanguage)
          .key,
    );
  }

  Future<void> _resetIntro() async {
    await IntroProvider.resetIntroCompleted();
  }

  Future<void> _resetLanguage() async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    const defaultLanguageCode = 'en';
    await languageProvider.setLanguage(defaultLanguageCode);

    if (!mounted) return;

    setSelectedLanguage(
      languageMap.entries
          .firstWhere((entry) => entry.value == defaultLanguageCode)
          .key,
    );
  }

  Future<void> _resetTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.resetSettings();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: customTheme?.backgroundGradient,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language Dropdown
                ListTile(
                  title: Text(AppLocalizations.of(context)!.language),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: languageMap.keys
                        .map((lang) => DropdownMenuItem(
                              value: lang,
                              child: Text(lang),
                            ))
                        .toList(),
                    onChanged: (newLang) async {
                      if (newLang == null) return;

                      setSelectedLanguage(newLang);
                      final languageCode = languageMap[newLang]!;
                      await Provider.of<LanguageProvider>(context,
                              listen: false)
                          .setLanguage(languageCode);
                    },
                  ),
                ),
                const Divider(),

                // Use System Theme Toggle
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.useSystemTheme),
                  value: themeProvider.useSystemTheme,
                  onChanged: (value) async {
                    await themeProvider.setUseSystemTheme(value);
                  },
                ),

                // Dark Theme Toggle
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.darkTheme),
                  value: themeProvider.isDarkTheme,
                  onChanged: themeProvider.useSystemTheme
                      ? null
                      : (value) async {
                          await themeProvider.setIsDarkTheme(value);
                        },
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () => {
                      _resetIntro(),
                      _resetLanguage(),
                      _resetTheme(),
                      Navigator.of(context)
                          .pushReplacementNamed(LauncherScreen.routeName)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.factoryReset,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
