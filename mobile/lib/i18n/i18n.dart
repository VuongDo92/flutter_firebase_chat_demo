import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sprintf/sprintf.dart';

import 'application.dart';

class I18n {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues;

  I18n(Locale locale) {
    this.locale = locale;
    _localisedValues = null;
  }

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  static const LocalizationsDelegate<I18n> delegate = I18nDelegate();

  static Future<I18n> load(Locale locale) async {
    I18n i18n = I18n(locale);
    String jsonContent = await rootBundle
        .loadString("assets/locale/${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);
    return i18n;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    return _localisedValues == null
        ? ''
        : _localisedValues[key] ?? "${key} not found";
  }

  TextSpan formattedText(
      {String key,
      String originalText,
      @required TextStyle defaultStyle,
      @required Map<String, TextStyle> replacements}) {
    if (_localisedValues == null) return const TextSpan(text: '');

    String originalString =
        originalText != null ? originalText : _localisedValues[key].toString();
    List<TextSpan> spans = List();
    replacements.forEach((text, style) {
      List<String> splitStrings = originalString.split('{{0}}');
      spans.add(TextSpan(text: splitStrings[0], style: defaultStyle));
      spans.add(TextSpan(text: text, style: style));
      originalString = originalString.replaceFirst('{{0}}', '');
      if (splitStrings.length > 1 &&
          splitStrings[1].isNotEmpty &&
          !splitStrings[1].contains('{{0}}')) {
        spans.add(TextSpan(text: splitStrings[1], style: defaultStyle));
      }
    });
    return TextSpan(style: defaultStyle, children: spans);
  }

  String formattedString(key, {List<dynamic> replacements}) {
    if (_localisedValues == null) return null;
    String originalString = _localisedValues[key]?.toString();
    if (originalString == null) return null;
    var index = 0;
    return originalString.replaceAllMapped('{{0}}', (match) {
      final str = replacements[index]?.toString() ?? '';
      index++;
      return str;
    });
  }

  String plural(String key, dynamic value) {
    if (_localisedValues == null ||
        _localisedValues.containsKey(key) == false) {
      return '';
    }
    String res = '';
    if (value == 1) {
      res = _localisedValues[key]['one'];
    } else {
      res = _localisedValues[key]['other'];
    }

    return res != null ? res.replaceFirst(RegExp(r'{}'), '$value') : '';
  }

  String format(String text, var args) {
    return sprintf(text, args);
  }

  String pluralFormat(String key, dynamic value) {
    if (_localisedValues == null) return '';
    String res = '';
    if (value == 1) {
      res = _localisedValues[key]['one'];
    } else {
      res = _localisedValues[key]['other'];
    }
    var text = res.replaceFirst(RegExp(r'{}'), '$value');
    return format(text, [value]);
  }

  /// Helpers for sports
  ///
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  final Locale newLocale;

  const I18nDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<I18n> load(Locale locale) {
    return I18n.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<I18n> old) {
    if (old is I18nDelegate) {
      return newLocale != old.newLocale;
    }
    return true;
  }
}
