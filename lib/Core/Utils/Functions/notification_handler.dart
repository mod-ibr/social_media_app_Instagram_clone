import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:instagram/Core/Utils/Constants/k_constants.dart';
import 'package:instagram/Core/Utils/Functions/animated_navigation.dart';
import 'package:instagram/Features/Instagram/View/Widgets/HomeTapViewWidgets/activity_page.dart';

class NotificationHandler {
  // All messages contain a data field with the key 'type'.
  Future<void> setupInteractedMessage(context) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage, context);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message, context));

    // Also handle any interaction when the app is in the Foreground via a
    // Stream listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // _handleMessage(message, context);
        // TODO : Make a red point Indecator over the Activity Icon.
      }
    });
  }

  void _handleMessage(RemoteMessage message, context) {
    String messageType = message.data['type'];
    print('============ FROM NOTIFICATION HANDLER =============');
    print('Message : $message');
    if (messageType == KConstants.kFCMLikeType) {
      // Navigate to Notification Page
      AnimatedNavigation()
          .navigateAndPush(widget: const ActivityPage(), context: context);
    }
  }
}
