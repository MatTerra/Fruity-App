import 'package:flutter/material.dart';
import 'package:fruity/pages/propose_species_page.dart';

class ProposeSpeciesButton extends StatelessWidget {
  const ProposeSpeciesButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProposeSpeciesPage()));
      },
      tooltip: 'Propor nova espécie',
      child: const Icon(Icons.add),
    );
  }
}
