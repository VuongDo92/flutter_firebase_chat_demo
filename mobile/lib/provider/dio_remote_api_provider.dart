import 'package:bittrex_app/app.dart';
import 'package:bittrex_app/config/env.dart';
import 'package:core/repositories/providers/providers.dart';
import 'package:dio/dio.dart';

import 'dio_api_provider.dart';

class DioRemoteApiProvider implements RemoteApiProvider {
  final Dio _dio;
  App app;

  DioRemoteApiProvider(String baseUrl) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    // Perform JSON operation in background
    (_dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    if (isInDebugMode) {
      _dio.interceptors
          .add(LogInterceptor(responseBody: false, responseHeader: true));
    }
    _dio.interceptors.add(InterceptorsWrapper(onError: (e) {
      if (this.app != null) {
        final exception = transformException(e);
        if (this.app != null &&
            (exception is UnauthorizedException ||
                exception is DeprecationException)) {
          this.app.onError(exception);
        }
      }
    }));
  }

  @override
  Future<dynamic> fetchConfig() async {
    try {} catch (exception) {
      throw transformException(exception);
    }
  }

  @override
  registerApp(app) {
    return this.app = app;
  }
}
