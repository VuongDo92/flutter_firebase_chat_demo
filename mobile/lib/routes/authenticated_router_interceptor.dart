import 'package:bittrex_app/config/env.dart';
import 'package:bittrex_app/routes/routes.dart';
import 'package:core/repositories/providers/api_provider.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:provider/provider.dart';

import 'router_interceptor.dart';
import 'router_settings.dart';

final apiProvider = kiwi.Container().resolve<ApiProvider>();

class AuthenticatedRouterInterceptor with RouterInterceptor {
  @override
  String get interceptorId => 'AUTHENTICATED';

  @override
  int get interceptorPriority => 5;

  @override
  bool canHandleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  }) {
    final env = Provider.of<Env>(context);

    if (uri.path.isEmpty) {
      return false;
    }
    if (uri.toString().contains('blog.rivi.co') ||
        uri.toString().contains('page.rivi.co') ||
        uri.toString().contains('l.${env.host}')) {
      return false;
    }

    /// TODO implement for account authen
//    AccountRepository accountRepository =
//        kiwi.Container().resolve<AccountRepository>();
//    return accountRepository.account != null;

    return true;
  }

  Future _defaultRouteHandler(BuildContext context, String path) async {
    final components = path.replaceRange(0, 1, '').split('/');
    final component1 = components.first;

    if (component1.contains('@') && components.length > 1) {
      return Routes.router
          .navigateTo(context, path.replaceAll('$component1/', ''));
    }

    /// TODO: fetch profile & summary-profile
//    final fetchProfile = apiProvider.fetchPlayerProfile(component1);
//    final fetchPartner = apiProvider.fetchPartnerSummary(component1);
    try {
//      final results = await showLoadingPopup(
//        context,
//        Future.wait([
//          fetchProfile.catchError((_) => null),
//          fetchPartner.catchError((_) => null),
//        ]),
//      );
//      final currentProfile = Provider.of<AccountStore>(context).profile;
//
//      if (results.first != null) {
//        if (currentProfile.id == (results.first as Profile).id) {
//          Routes.router.navigateTo(context, '/you');
//        } else {
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) => PlayerProfileScreen(profile: results.first),
//            ),
//          );
//        }
//      } else if (results.last != null) {
//        Navigator.of(context).push(
//          MaterialPageRoute(
//            builder: (context) => BusinessScreen(
//                  partnerProfile: (results.last as Partner).partnerProfile,
//                  partnerId: (results.last as Partner).partnerProfile.partnerId,
//                  slug: component1,
//                ),
//          ),
//        );
//      } else {}
    } catch (error) {
      Routes.router.navigateTo(context, path);
    }
  }

  @override
  Future handleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  }) {
    if (Routes.router.match(uri.path) != null) {
      return Routes.router.navigateTo(
        context,
        uri.path + (uri.query?.isNotEmpty == true ? '?${uri.query}' : ''),
        replace: transitionSettings?.replace ?? false,
        clearStack: transitionSettings?.clearStack ?? false,
        transition: transitionSettings?.transitionType ?? TransitionType.native,
        transitionDuration: transitionSettings?.transitionDuration,
        transitionBuilder: transitionSettings?.transitionBuilder,
      );
    } else {
      // TODO: accept transitionSettings
      return _defaultRouteHandler(context, uri.path);
    }
  }
}
