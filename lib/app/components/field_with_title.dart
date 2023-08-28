import 'package:flutter/material.dart';

class FieldWithTitle extends StatelessWidget {
  const FieldWithTitle({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey))),
      Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
          child: Text(
            content,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ))
    ]);
  }
}
