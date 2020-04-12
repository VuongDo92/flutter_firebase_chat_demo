import 'dart:convert';
import 'dart:io';

import 'package:core/repositories/providers/api_provider.dart';
import 'package:core/repositories/providers/providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../app.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class ApiCancelable<T> implements CancelableFuture<T> {
  CancelToken cancelToken;
  Future<T> future;

  ApiCancelable({this.future, this.cancelToken})
      : assert(future != null),
        assert(cancelToken != null);

  @override
  void cancel() {
    try {
      cancelToken?.cancel();
    } catch (e) {
      // ignore
    }
  }
}

class DioApiProvider implements ApiProvider {
  @override
  String deviceId;

  @override
  String sessionToken;

  String deviceType;
  String deviceModel;

  String appVersion;
  String osVersion;

  String timezone;
  String gcmToken;

  App app;

  final Dio _dio;

  DioApiProvider(String baseUrl) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    // Perform JSON operation in background
    (_dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    if (isInDebugMode) {
      _dio.interceptors
          .add(LogInterceptor(responseBody: false, responseHeader: true));
    }

    // Inject headers
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
        if (sessionToken != null) {
          options.headers['Authorization'] = sessionToken;
        }

        // Custom headers
//        if (deviceId != null) {
//          options.headers['x-device-id'] = deviceId;
//        }
//        if (deviceType != null) {
//          options.headers['x-device-type'] = deviceType;
//        }
//        if (appVersion != null) {
//          options.headers['x-app-version'] = appVersion;
//        }
//        if (timezone != null) {
//          options.headers['x-timezone'] = timezone;
//        }
//        options.headers['Accept-Encoding'] = 'gzip';
        return options;
      }, onError: (DioError e) {
        final exception = transformException(e);
        if (this.app != null &&
            (exception is UnauthorizedException ||
                exception is DeprecationException)) {
          this.app.onError(exception);
        }
      }),
    );
  }

  @override
  Future<AuthenticationResult> authenticate(
      String token, IdentityProvider provider, String referralLink) {
    // TODO: implement authenticate
    return null;
  }

  @override
  Future logout() {
    // TODO: implement logout
    return null;
  }

  @override
  registerApp(app) {
    return this.app = app;
  }

  @override
  Future registerDevice(
      {String pushToken, String deviceId, int applicationBadge = null}) {
    // TODO: implement registerDevice
    return null;
  }
}

DataProviderException transformException(dynamic exception) {
  if (exception is DataProviderException) {
    return exception;
  }
  if (exception is DioError) {
    if (exception.type == DioErrorType.CANCEL) {
      return CancelException();
    }
  }
  print('API exception: ' + exception.toString());
  final defaultErrorMessage = 'Oops! Something went wrong!';
  if (exception is DioError) {
    switch (exception.type) {
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
      case DioErrorType.SEND_TIMEOUT:
        return TimeOutException();
      case DioErrorType.DEFAULT:
        final error = exception.error;
        if (error != null) {
          if (error is SocketException) {
            return ConnectionException();
          }
        }
        break;
      default:
    }
    if (exception.type == DioErrorType.RESPONSE) {
      final Map<String, dynamic> data =
          exception.response?.data is Map<String, dynamic>
              ? exception.response.data
              : {};
      final title = data['title'] ?? data['errorTitle'];
      final message = data['message'] ??
          data['errorMessage'] ??
          data['msg'] ??
          (title == null ? defaultErrorMessage : null);
      switch (exception.response?.statusCode) {
        case 400:
          return RejectedException(
            title: title,
            message: message,
            originalException: exception,
          );
        case 401:
          return UnauthorizedException(
            originalException: exception,
          );
        case 403:
          return ForbiddenException(message: "You do not have access");
        case 404:
          return NotfoundException(
            title: title,
            message: message,
            originalException: exception,
          );
        case 410:
          return DeprecationException(
            originalException: exception,
          );
        default:
          break;
      }
    }
  }
//    todo: defile a deserializationError in the SeriallizationModel
//    if (exception is DeserializationError) {
//      return UnknownException(
//        message: defaultErrorMessage,
//        isTemporary: false, // Won't work if retry
//        originalException: exception,
//      );
//    }
  return UnknownException(
    message: defaultErrorMessage,
    originalException: exception,
  );
}

parseJson(String text) {
  /// There seems to be an issue with compute in debug mode and enabling debuggers,
  /// So we only enable background json decoding in release mode
  if (isInDebugMode) {
    return jsonDecode(text);
  } else {
    return compute(_parseAndDecode, text);
  }
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}
