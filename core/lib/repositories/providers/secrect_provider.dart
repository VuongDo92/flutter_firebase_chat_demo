/// Interface for a class that store secret information
abstract class SecretProvider {
  Future<String> getSessionToken();
  Future saveSessionToken(String token);
  Future deleteSessionToken() => saveSessionToken(null);

  Future<bool> setString(String key, String value);
  Future<String> getString(String key);
}
