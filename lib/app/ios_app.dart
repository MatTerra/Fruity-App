import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSApp extends StatelessWidget {
  const IOSApp(
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
    return CupertinoApp(
      title: title,
      theme: const CupertinoThemeData(
        primaryColor: Colors.green,
      ),
      locale: const Locale("pt", "BR"),
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
