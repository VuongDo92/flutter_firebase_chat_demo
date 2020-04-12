import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import 'router_interceptor.dart';
import 'router_settings.dart';

/// This router primary job is to store referrer link and stop the links from being routed
class UnauthenticatedRouterInterceptor with RouterInterceptor {
  @override
  String get interceptorId => 'UNAUTHENTICATED';

  @override
  int get interceptorPriority => 5;

  @override
  bool canHandleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  }) {
    /// TODO: implement
//    AccountRepository accountRepository =
//        kiwi.Container().resolve<AccountRepository>();
//    return accountRepository.account == null;
    return true;
  }

  @override
  Future handleRoute(
    BuildContext context,
    Uri uri, {
    RouteTransitionSettings transitionSettings = null,
    Map<String, dynamic> parameters = const {},
  }) {
//    AccountRepository accountRepository =
//        kiwi.Container().resolve<AccountRepository>();
//    accountRepository.setReferralLink(uri.toString());
    return null;
  }
}
