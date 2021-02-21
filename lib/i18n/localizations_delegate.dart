import 'package:flutter/material.dart';
import 'package:to_do/i18n/languages/language_es.dart';

import 'Languages.dart';
import 'languages/language_en.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'es':
        return LanguageEs();
      default:
        return LanguageEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
  
}