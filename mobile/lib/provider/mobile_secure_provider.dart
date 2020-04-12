import 'dart:io' show Platform;

import 'package:core/repositories/providers/secrect_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageProvider extends SecretProvider {

  static String get sessionKey => Platform.isIOS ? "session" : "app_session";
  static final iOSOptions _iOSOptions = iOSOptions(groupId: null);
  @override
  Future<String> getSessionToken() => getString(sessionKey);

  @override
  Future saveSessionToken(String token) => setString(sessionKey, token);

  @override
  Future<bool> setString(String key, String value) {
    final storage = const FlutterSecureStorage();
    if (value == null) {
      return storage
          .delete(
        key: key,
        iOptions: _iOSOptions,
      )
          .then((_) => true);
    } else {
      return storage
          .write(
        key: key,
        value: value,
        iOptions: _iOSOptions,
      )
          .then((_) => true);
    }
  }

  @override
  Future<String> getString(String key) {
    final storage = const FlutterSecureStorage();
    return storage.read(
      key: key,
      iOptions: _iOSOptions,
    );
  }
//
//  @override
//  Future deleteToken() {
//    // TODO: implement deleteToken
//    return null;
//  }
//
//  @override
//  Future<String> getToken() {
//    // TODO: implement getToken
//    return null;
//  }
//
//  @override
//  Future saveToken(String token) {
//    // TODO: implement saveToken
//    return null;
//  }

}
