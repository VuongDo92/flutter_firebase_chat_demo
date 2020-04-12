
abstract class RemoteConfigProvider{
  Future<void> init();
}

class MobileConfigProvider implements RemoteConfigProvider {
  @override
  Future<void> init() {
    return null;
  }

}