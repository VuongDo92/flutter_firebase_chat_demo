import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

class ExceptionUtils {
  /**
   * Show exception via toast or alert (automatically)
   * return if the exception is handled
   * if context is null, only toast can be shown
   */
  static bool show(dynamic exception, {BuildContext context = null}) {
    print('Handling exception ' + exception.toString());
    _showToast(errorMessage(exception, context: context));
    return true;
  }

  static String errorMessage(dynamic exception, {BuildContext context = null}) {
    print('Handling exception' + exception.toString());
    if (exception is String) {
      return exception;
    } else if (exception is PlatformException && exception.message != null) {
      return exception.message;
    } else {
      return exception.toString(); // TODO: use default message
    }
  }

  static bool _showToast(String string, {BuildContext context = null}) {
    // prevent this being called when widget is building
    new Future.delayed(
      Duration.zero,
      () => showToast(
            string.substring(
                0, min(200, string.length - 1)), // show max 200 chars
            duration: const Duration(seconds: 5),
            context: context,
            textPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          ),
    );
    return true;
  }
}
