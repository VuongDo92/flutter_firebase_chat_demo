import 'package:flutter/services.dart';

typedef CallHandler = Future<dynamic> Function(MethodCall call);

class PlatformChannel {
  static const _CHANNEL_NAME = 'ph.com.channel.platform';
  static final _channel = const MethodChannel(_CHANNEL_NAME);

  PlatformChannel(CallHandler callHandler) {
    _channel.setMethodCallHandler(callHandler);
  }
  Future<String> getDeviceUUID() =>
      _channel.invokeMethod<String>('GET_DEVICE_UUID');
}
