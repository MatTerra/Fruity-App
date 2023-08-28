import 'package:flutter/material.dart';

class SpeciesListItemLoader extends StatefulWidget {
  const SpeciesListItemLoader({Key? key}) : super(key: key);

  @override
  _SpeciesListItemLoaderState createState() => _SpeciesListItemLoaderState();
}

class _SpeciesListItemLoaderState extends State<SpeciesListItemLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    animation = TweenSequence<Color?>([
      TweenSequenceItem<Color?>(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.black26,
          end: const Color(0x22FFFFFF),
        ),
      ),
      TweenSequenceItem<Color?>(
        weight: 1.0,
        tween: ColorTween(
          begin: const Color(0x22FFFFFF),
          end: Colors.black26,
        ),
      ),
    ]).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {},
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: animation.value,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(1, 15, 1, 1),
              height: 13.125,
              width: 120,
              color: animation.value,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
              height: 15,
              width: double.infinity,
              color: animation.value,
            ),
            const SizedBox(
              height: 7,
            )
          ],
        ),
        subtitle: Container(
          margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
          height: 26.25,
          width: double.infinity,
          color: animation.value,
        ));
  }
}
