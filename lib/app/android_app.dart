import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AndroidApp extends StatelessWidget {
  const AndroidApp(
      {super.key,
      required this.providers,
      required this.title,
      required this.initialRoute,
      required this.routes});

  final List<EmailAuthProvider> providers;
  final String title;
  final String initialRoute;
  final Map<String, Widget Function(BuildContext)> routes;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      locale: const Locale("pt", "BR"),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: routes,
    );
  }
}
