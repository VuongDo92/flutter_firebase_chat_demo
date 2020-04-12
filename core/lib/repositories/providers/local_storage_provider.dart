abstract class LocalStorageProvider {
  Future<bool> getBool(String key);
  Future<int> getInt(String key);
  Future<double> getDouble(String key);
  Future<String> getString(String key);

  Future<bool> setBool(String key, bool value);
  Future<bool> setInt(String key, int value);
  Future<bool> setDouble(String key, double value);
  Future<bool> setString(String key, String value);

  Future<bool> contains(String key);
  Future<bool> remove(String key);
}
