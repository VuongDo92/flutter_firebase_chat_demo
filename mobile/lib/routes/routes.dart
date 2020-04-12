import 'package:fluro/fluro.dart';
import 'route_handlers.dart';

class Routes {
  static final router = Router();

  static const String root = "/";
  static String demoSimple = "/demo";
  static String demoSimpleFixedTrans = "/demo/fixedtrans";
  static String demoFunc = "/demo/func";
  static String deepLink = "/message";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(handlerFunc: (
      context,
      params,
    ) {
      print(params);
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });

    router.define(root, handler: rootHandler);
    router.define(demoSimple, handler: demoRouteHandler);
    router.define(demoSimpleFixedTrans,
        handler: demoRouteHandler, transitionType: TransitionType.inFromLeft);
    router.define(demoFunc, handler: demoFunctionHandler);
    router.define(deepLink, handler: deepLinkHandler);
  }
}
