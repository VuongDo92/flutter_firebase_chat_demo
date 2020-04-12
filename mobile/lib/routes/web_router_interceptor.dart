import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'router_interceptor.dart';
import 'router_settings.dart';

class WebRouterInterceptor with RouterInterceptor {
  String get interceptorId => 'WEB';

  int get interceptorPriority => 1;

  bool canHandleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  }) {
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      final onlyAllowWebDomain = transitionSettings?.onlyAllowWebDomain ?? true;
      if (onlyAllowWebDomain &&
          RouterInterceptor.isAppDomain(context, uri) == false) {
        return false;
      }
      return true;
    }
    return false;
  }

  Future handleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  }) async {
//    final shouldAddToken = transitionSettings?.addTokenWhenRedirectWeb == true;
//    AccountRepository accountRepository =
//        kiwi.Container().resolve<AccountRepository>();
//    final env = Provider.of<Env>(context);
//    final channel = Provider.of<PlatformChannel>(context);
//
//    if (uri.host.contains('l.${env.host}')) {
//      return await showLoadingPopup(
//          context, channel.handleBranchLink(uri.toString()));
//    }
//
//    String token = await accountRepository.getToken();
//    Map<String, dynamic> queryParameters = Map.from(uri.queryParameters);
//
//    if (shouldAddToken && token?.isNotEmpty == true) {
//      final host = uri.host;
//      if (host?.isNotEmpty == true) {
//        for (var domain in env.riviDomains) {
//          if (host.endsWith(domain)) {
//            queryParameters['session'] = token;
//          }
//        }
//      }
//    }
//
//    Uri updatedUri = Uri(
//        scheme: uri.scheme,
//        userInfo: uri.userInfo,
//        host: uri.host,
//        port: uri.port,
//        path: uri.path,
//        query: uri.query,
//        queryParameters: queryParameters);
//
//    try {
//      return await launch(
//        updatedUri.toString(),
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

class StaticPagesRouterInterceptor extends WebRouterInterceptor {
  @override
  String get interceptorId => 'STATIC_PAGES';

  int get interceptorPriority => 8;

  bool canHandleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  }) {
    final canHandle = super.canHandleRoute(
      context,
      uri,
      transitionSettings: transitionSettings,
      parameters: parameters,
    );
    return canHandle &&
        (uri.path.startsWith('/p/') || uri.toString().contains('blog.rivi.co'));
  }
}
