typedef Future<dynamic> NotificationMessageCallback(
    Map<String, dynamic> message);

abstract class PushProvider {
  NotificationMessageCallback backgroundMessage;
  NotificationMessageCallback foregroundMessage;

  String pushToken;

  Future init({
    NotificationMessageCallback onForegroundMessage,
    NotificationMessageCallback onBackgroundMessage,
  });

  Future setConfigure({
    NotificationMessageCallback onForegroundMessage,
    NotificationMessageCallback onBackgroundMessage,
  });

  void requestNotificationPermission();

  void clearNotificationMessages(String type, String key,
      {bool clearNotification});
}
