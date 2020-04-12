import 'package:bittrex_app/config/env.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'rate_app_router_interceptor.dart';
import 'router_interceptor.dart';
import 'router_settings.dart';
import 'web_router_interceptor.dart';

class AppRouter {
  static String _deeplinkScheme;
  static Future route(
    BuildContext context,
    String url, {
    RouteTransitionSettings transitionSettings,
    Map<String, dynamic> parameters = const {},
  }) async {
    if (url == null || url.isEmpty == true) {
      return null;
    }
    Uri uri;
    try {
      final env = Provider.of<Env>(context);
      if (url.contains(env.host) &&
          !url.contains('http') &&
          !url.contains('https')) {
        url = 'https://$url';
      }

      uri = Uri.parse(url);
    } catch (e) {
      try {
        uri = Uri.parse(AppRouter._deeplinkScheme + '://' + url);
      } catch (e) {}
      print('Failed to parse link ${e.toString()}');
    }

    if (uri.scheme == AppRouter._deeplinkScheme) {
      uri = Uri(
          scheme: AppRouter._deeplinkScheme,
          host: 'rivi',
          path: uri.host + ((uri.path.isNotEmpty) ? '/' + uri.path : ''));
    }

    if (uri != null) {
      return _routeUri(
        context,
        uri,
        transitionSettings: transitionSettings,
        parameters: parameters,
      );
    }
  }

  static Future _routeUri(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings,
    Map<String, dynamic> parameters = const {},
  }) async {
    for (var interceptor in _interceptors) {
      if (interceptor.canHandleRoute(
        context,
        uri,
        transitionSettings: transitionSettings,
        parameters: parameters,
      )) {
        debugPrint(
            '[Router] handling route ${uri.toString()} by ${interceptor.interceptorId ?? interceptor.toString()}');
        return interceptor.handleRoute(
          context,
          uri,
          transitionSettings: transitionSettings,
          parameters: parameters,
        );
      }
    }

    print('[Router] Unhandled route ${uri.toString()}');
  }

  static init(String deeplinkScheme) {
    _deeplinkScheme = deeplinkScheme;
//    register(FirebaseRouterInterceptor());
//    register(StaticPagesRouterInterceptor());
    register(RateAppRouterInterceptor());
//    register(UnauthenticatedRouterInterceptor());
//    register(AuthenticatedRouterInterceptor());
    register(WebRouterInterceptor());
  }

  static List<RouterInterceptor> _interceptors = [];

  static register(RouterInterceptor interceptor) {
    _interceptors.insert(0, interceptor);
    _interceptors.sort((a, b) {
      if (a.interceptorPriority == b.interceptorPriority) {
        return _interceptors.indexOf(a).compareTo(_interceptors.indexOf(b));
      } else {
        return b.interceptorPriority.compareTo(a.interceptorPriority);
      }
    });
  }

  static deregister(RouterInterceptor interceptor) =>
      _interceptors.remove(interceptor);

  static bool isAppLink(Uri uri, Env env) {
    if (uri.scheme == env.deeplinkScheme) {
      return true;
    }
    final host = uri.host;
    if (host?.isNotEmpty == true) {
      for (var domain in env.domains) {
        if (host.endsWith(domain)) {
          return true;
        }
      }
    }
    return false;
  }

  static Future routeWebUrl(
    BuildContext context,
    Uri url, {
    bool addToken = false,
  }) async {
//    AccountRepository accountRepository =
//    kiwi.Container().resolve<AccountRepository>();
//    String token = await accountRepository.getToken();
//    if (addToken && token?.isNotEmpty == true) {
//      url.queryParameters['session'] = token;
//    }
//    try {
//      await launch(
//        url.toString(),
//        option: const CustomTabsOption(
//            toolbarColor: Colors.white,
//            enableDefaultShare: true,
//            enableUrlBarHiding: true,
//            showPageTitle: true),
//      );
//    } catch (e) {
//      // An exception is thrown if browser app is not installed on Android device.
//      debugPrint(e.toString());
//    }
  }
}
