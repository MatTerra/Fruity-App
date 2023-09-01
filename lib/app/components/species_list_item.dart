import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruity/pages/species_detail_page.dart';
import 'package:fruity/domain/entities/species.dart';

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
