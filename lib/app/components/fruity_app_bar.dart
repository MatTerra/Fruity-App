import 'package:flutter/material.dart';
import 'package:fruity/app/components/profile_button.dart';

class FruityAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  const FruityAppBar(
    this.title, {
    Key? key,
  })  : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: true,
    );
  }
}
