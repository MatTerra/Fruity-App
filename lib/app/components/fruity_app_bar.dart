import 'package:flutter/material.dart';
import 'package:fruity/app/components/species_search_delegate.dart';

class FruityAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  const FruityAppBar(this.title, {
    Key? key,
  })
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: true,
      actions: [IconButton(onPressed: () {
        showSearch(context: context, delegate: SpeciesSearchDelegate());
      }, icon: const Icon(Icons.search))
      ],
    );
  }
}
