import 'dart:async';
import 'dart:isolate';

import 'package:bittrex_app/app.dart';
import 'package:bittrex_app/provider/dio_api_provider.dart';
import 'package:bittrex_app/provider/dio_remote_api_provider.dart';
import 'package:bittrex_app/provider/firebase_push_provider.dart';
import 'package:bittrex_app/provider/mobile_provider.dart';
import 'package:core/repositories/authenticate_repository.dart';
import 'package:core/repositories/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

kiwi.Container container = kiwi.Container();

enum EnvType {
  DEVELOPMENT,
  STAGING,
  PRODUCTION,
}

abstract class Env {
  EnvType environmentType = EnvType.DEVELOPMENT;

  String appName;
  String apiBaseUrlConfig;
  String apiBaseUrl;

  ApiProvider apiProvider;
  RemoteApiProvider remoteApiProvider;

  // Image
  String cloudFrontUrl;
  String s3Bucket;
  List<String> s3Hosts = [
    'https://s3-ap-southeast-1.amazonaws.com',
    'https://s3.ap-southeast-1.amazonaws.com'
  ];
  String defaultProfilePictureKey = 'profiles/pictures/default.png';
  String fbHost = 'https://platform-lookaside.fbsbx.com';

  String host;

  List<String> domains;

  String deeplinkScheme;

  Env() {
    WidgetsFlutterBinding.ensureInitialized();
    _init();
  }

  Future _init() async {
    _registerProviders();
    _registerRepositories();

    final all = await Future.wait([
      container.resolve<AuthenticateRepository>().init(),
      container.resolve<LocalStorageProvider>().getString('locale'),
    ]);

    String localeString = all.last as String ?? 'en';

    // Set up error hooks and run app
    final app = App(
      env: this,
      locale: localeString != null ? Locale(localeString) : null,
    );

    if (remoteApiProvider is DioRemoteApiProvider) {
      remoteApiProvider.registerApp(app);
    }
    if (apiProvider is DioApiProvider) {
      apiProvider.registerApp(app);
    }

    bool isInDebugMode = false;
    assert(() {
      isInDebugMode = true;
      return true;
    }());

    /**
     * todo first init & config Crashlytics
     * ***/

    FlutterError.onError = (FlutterErrorDetails details) async {
      if (isInDebugMode) {
        // In development mode simply print to console.
        FlutterError.dumpErrorToConsole(details);
      }
      if (details.stack != null) {
        debugPrint(details.toString());
      }
    };
    Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
      final isolateError = pair as List<dynamic>;
      await app.onError(
        isolateError.first.toString(),
        stack: isolateError.last.toString(),
      );
    }).sendPort);

    /// Disabling red screen of death in release mode
    if (!isInDebugMode) {
      ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    }
    // Run app
    return runZoned(() async {
      runApp(app);
    }, onError: (error, stackTrace) async {
      app.onError(error, stack: stackTrace);
    });
  }

  void _registerProviders() async {
    container.registerSingleton<PushProvider, FirebasePushProvider>(
        (c) => FirebasePushProvider());

    container.registerSingleton<RemoteApiProvider, DioRemoteApiProvider>(
        (c) => DioRemoteApiProvider(apiBaseUrlConfig));

    container.registerSingleton<ApiProvider, DioApiProvider>(
        (c) => DioApiProvider(apiBaseUrl));

    container.registerSingleton<SecretProvider, SecureStorageProvider>(
        (c) => SecureStorageProvider());

    container.registerSingleton<LocalStorageProvider, MobileStorageProvider>(
        (c) => MobileStorageProvider());

    container.registerSingleton<RemoteConfigProvider, MobileConfigProvider>(
        (c) => MobileConfigProvider());
  }

  void _registerRepositories() {
    final apiRemoteProvider = container.resolve<RemoteApiProvider>();
    final apiProvider = container.resolve<ApiProvider>();
    final secretProvider = container.resolve<SecretProvider>();
    final localStorageProvider = container.resolve<LocalStorageProvider>();
    final pushProvider = container.resolve<PushProvider>();

    final AuthenticateRepository authenticateRepo = AuthenticateRepository(
        apiRemoteProvider,
        apiProvider,
        secretProvider,
        localStorageProvider,
        pushProvider);

    container.registerSingleton((c) => authenticateRepo);
  }
}
