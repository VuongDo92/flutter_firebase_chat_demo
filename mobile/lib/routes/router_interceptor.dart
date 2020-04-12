import 'package:bittrex_app/config/env.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'router_settings.dart';

abstract class RouterInterceptor {
  String get interceptorId => null;

  /// [priority] is from 0-15, 5 being normal and 15 being highest priority
  /// If 2 interceptors with same priority, the one's added last will be handled first,
  /// It's for the case when 2 screens of the same classes
  /// [15]: unused
  /// [14]: must handled, like firebase links (reset password, forgot password, verify email)
  /// [13]: unused
  /// [12]: unused
  /// [11]: unused
  /// [10]: custom UI level here, like game tabs, profile tabs
  /// [9]: unused
  /// [8]: static pages rivi.co/p/homegrounds
  /// [7]: invoking actions: rate the app, etc
  /// [6]: unused
  /// [5]: this is the default level: authenticated and unauthenticated routes, home routes
  /// [4]: unused
  /// [3]: unused
  /// [2]: unused
  /// [1]: web links (https)
  /// [0]: unused
  ///
  int get interceptorPriority => 10;

  bool canHandleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  });

  Future handleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  });

  static bool isAppDomain(BuildContext context, Uri uri) {
    if ((uri.scheme == 'https' || uri.scheme == 'http') == false) {
      return false;
    }
    final env = Provider.of<Env>(context);
    for (var domain in env.domains) {
      if ((uri.host.endsWith(domain) || uri.host.endsWith('.${domain}')) ==
          true) {
        return true;
      }
    }
    return false;
  }

  static bool isDeeplink(BuildContext context, Uri uri) {
    final env = Provider.of<Env>(context);
    return uri.scheme == null ||
        uri.scheme.isEmpty == true ||
        uri.scheme == env.deeplinkScheme;
  }
}
