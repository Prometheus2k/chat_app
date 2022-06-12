import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chats/messages.dart';
import '../widgets/chats/new_message.dart';

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print('background message title: ${message.notification?.title}');
  print('background message: ${message.notification?.body}');
  return Future.delayed(Duration.zero); //Mock Future
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission(); // for IOS
    FirebaseMessaging.onMessage.listen(
      (message) {
        print('foreground message title: ${message.notification?.title}');
        print('foreground message body: ${message.notification?.body}');
        return;
      },
    );
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).textTheme.headline6!.color,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text('Logout'),
                  ],
                ),
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
