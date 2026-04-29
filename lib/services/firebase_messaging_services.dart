import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 رسالة في الخلفية: ${message.messageId}');
}

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
  FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// init
  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler);

    final bool permissionGranted = await _requestPermissions();
    if (!permissionGranted) {
      print('🚫 Notification permission not granted');
      return;
    }

    await _initializeLocalNotifications();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _firebaseMessaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      print('🔁 FCM Token updated: $token');
      // ابعته للسيرفر هنا
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);



    final RemoteMessage? initialMessage =
    await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// Permissions
  Future<bool> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔐 Permission status: ${settings.authorizationStatus}');
    return settings.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  /// Local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'إشعارات مهمة',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('📨 Foreground message: ${message.messageId}');
    if (Platform.isAndroid) {
      _showLocalNotification(message); // Android بس
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('📲 Notification opened: ${message.messageId}');
    print('📦 Data: ${message.data}');
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('👉 Local notification tapped: ${response.payload}');
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final data = message.data;

    final title = data['title'];
    final body = data['body'];

    if (title == null || body == null) return;

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'إشعارات مهمة',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
      payload: data.toString(),
    );
  }
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('📌 Subscribed to $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('📌 Unsubscribed from $topic');
  }

  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    _fcmToken = null;
    print('🗑️ FCM Token deleted');
  }
}
