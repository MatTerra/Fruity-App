import 'package:flutter/material.dart';
import 'package:fruity/domain/entities/species.dart';

import 'package:fruity/pages/create_tree_page.dart';

class CreateTreeButton extends StatelessWidget {
  Species species;

  CreateTreeButton({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateTreePage(
                      species: species,
                    )));
      },
      tooltip: 'Criar árvore',
      child: const Icon(Icons.add),
    );
  }
}
