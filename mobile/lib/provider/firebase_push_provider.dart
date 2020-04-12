import 'dart:io';

import 'package:core/repositories/providers/providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin localPushPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _backgroundMessage(Map<String, dynamic> message) async {
  print(":::TAG::: onBackgroundMessage: $message");

  await _showBackgroundNotification(message);
}

/// Schedules a notification that specifies a different icon, sound and vibration pattern
Future<void> _showBackgroundNotification(Map<String, dynamic> message) async {
  localPushPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) {
    return;
  });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  localPushPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) {
    return;
  });
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await localPushPlugin.show(0, message['data']['title'],
      message['data']['body'], platformChannelSpecifics,
      payload: 'item x');
}

class FirebasePushProvider implements PushProvider {
  String pushToken;
  FirebaseMessaging _firebaseMessaging;
  NotificationMessageCallback backgroundMessage;
  NotificationMessageCallback foregroundMessage;

  /// for android
  SelectNotificationCallback onSelectNotification;

  /// for ios
  DidReceiveLocalNotificationCallback onDidReceiveLocalNotification;

  @override
  void clearNotificationMessages(String type, String key,
      {bool clearNotification}) {
    if (clearNotification) {
      FlutterLocalNotificationsPlugin().cancel(key.hashCode);
    }
  }

  @override
  Future<void> setConfigure({
    NotificationMessageCallback onForegroundMessage,
    NotificationMessageCallback onBackgroundMessage,
  }) async {
    if (onBackgroundMessage != null) {
      this.backgroundMessage = onBackgroundMessage;
    }
    if (onForegroundMessage != null) {
      this.foregroundMessage = onForegroundMessage;
    }
    if (_firebaseMessaging == null) {
      return;
    }
    _firebaseMessaging.configure(
        onMessage: foregroundMessage,
        onLaunch: foregroundMessage,
        onResume: foregroundMessage);
  }

  @override
  Future<void> init({
    NotificationMessageCallback onForegroundMessage,
    NotificationMessageCallback onBackgroundMessage,
  }) async {
    /// init local-push-plugin
    localPushPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    localPushPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    /// init firebase-message plugin
    _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) async {
      debugPrint("Settings registered: $settings");
      pushToken = await _firebaseMessaging.getToken();
      print("Push Messaging token: $pushToken");
    });

    pushToken = await _firebaseMessaging.getToken();
    print("Push Messaging token: $pushToken");

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(":::TAG::: onMessage: $message");
        await _showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(":::TAG::: onLaunch: $message");
        await _showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print(":::TAG::: onResume: $message");
        await _showNotification(message);
      },
      onBackgroundMessage: Platform.isIOS ? null : _backgroundMessage,
    );
  }

  Future<void> _showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await localPushPlugin.show(0, message['data']['title'],
        message['data']['body'], platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  void requestNotificationPermission() {
    final iosNotificationSettings = const IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    );
    _firebaseMessaging.requestNotificationPermissions(iosNotificationSettings);
  }
}
