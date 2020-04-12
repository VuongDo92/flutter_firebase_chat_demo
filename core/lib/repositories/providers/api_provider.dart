import 'package:meta/meta.dart';

enum IdentityProvider {
  Facebook,
  Firebase,
}

// Extend this class
abstract class ImageSource {
  Future<List<int>> getBytes();

  int get width;

  int get height;

  String get contentType;
}

abstract class CancelableFuture<T> {
  Future<T> future;

  void cancel();
}

class AuthenticationResult {
//  Account account;
  String sessionToken;
  bool isSignup;

  AuthenticationResult({this.sessionToken, this.isSignup});
}

abstract class RemoteApiProvider {
  @required
  registerApp(dynamic app);

  Future<dynamic> fetchConfig();
}

abstract class ApiProvider {
  String sessionToken;
  String deviceId;

  // Account + Authentication
  Future<AuthenticationResult> authenticate(
    String token,
    IdentityProvider provider,
    String referralLink,
  );

  @required
  registerApp(dynamic app);

  Future logout();

  Future registerDevice({
    @required String pushToken,
    @required String deviceId,
    int applicationBadge,
  });
}
