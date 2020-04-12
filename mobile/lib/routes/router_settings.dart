import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class RouteTransitionSettings {
  final bool addTokenWhenRedirectWeb;
  final bool onlyAllowWebDomain;
  final RouteSettings routeSettings;
  final TransitionType transitionType;
  final Duration transitionDuration;
  final RouteTransitionsBuilder transitionBuilder;
  final bool replace;
  final bool clearStack;

  RouteTransitionSettings({
    this.addTokenWhenRedirectWeb = true,
    this.onlyAllowWebDomain = true,
    this.routeSettings,
    this.transitionType,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.replace = false,
    this.clearStack = false,
    this.transitionBuilder,
  });
}
