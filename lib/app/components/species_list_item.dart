import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruity/app/components/fruity_drawer.dart';
import 'package:fruity/domain/repository/species_repository.dart';
import 'package:fruity/infra/repository/species_http_repository.dart';
import 'package:fruity/pages/propose_species.dart';
import 'package:fruity/pages/speciesDetailPage.dart';

import 'fruity_app_bar.dart';
import '../../domain/entities/species.dart';

class SpeciesListItem extends StatelessWidget {
  final Species species;
  const SpeciesListItem({
    super.key,
    required this.species
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SpeciesDetailPage(species: species)));
        },
        leading: Container(
          height: 50,
          width: 50,
          child: CircleAvatar(
            backgroundImage: species.picturesUrl!.isNotEmpty
                ? NetworkImage(species.picturesUrl![0])
                : AssetImage('assets/tree-silhouette.png') as ImageProvider,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(species.scientificName,
                style: const TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
            Text(species.popularNames!.join(", ")),
            const SizedBox(
              height: 7,
            )
          ],
        ),
        subtitle: Text(
          species.description!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ));
  }
}
