import 'dart:io';

import 'package:core/repositories/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import 'router_interceptor.dart';
import 'router_settings.dart';

final apiProvider = kiwi.Container().resolve<ApiProvider>();

class RateAppRouterInterceptor with RouterInterceptor {
  @override
  String get interceptorId => 'RATE_APP';

  @override
  int get interceptorPriority => 7;

  @override
  bool canHandleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  }) {
    return uri.path == '/thanks';
  }

  @override
  Future handleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  }) {
    return launch(
        Platform.isIOS ? Constants.appStoreUrl : Constants.playStoreUrl);
  }
}
