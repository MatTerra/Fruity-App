import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruity/pages/species_detail_page.dart';
import 'package:fruity/domain/entities/species.dart';

import '../../infra/repository/species_http_repository.dart';

class SpeciesListItem extends StatelessWidget {
  final Species species;

  const SpeciesListItem({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SpeciesDetailPage(species: species)));
        },
        trailing: IconButton(
            onPressed: () {
              species.favorite ?? false ? _unfavoriteSpecies(context) : _favoriteSpecies(context);
            },
            icon: Icon(species.favorite ?? false ? Icons.favorite : Icons.favorite_border)),
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
            Text(species.popularNames!.join(", "),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(species.scientificName,
                style: const TextStyle(fontStyle: FontStyle.italic)),
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

  void _favoriteSpecies(BuildContext context) async {
    var messengerState = ScaffoldMessenger.of(context);
    var repository = await SpeciesHTTPRepository.create();

    if (!await repository.favoriteSpecies(species.id!)) {
      messengerState.showSnackBar(const SnackBar(
          content: Text('Não foi possível atualizar os favoritos.')));
    }
  }

  void _unfavoriteSpecies(BuildContext context) async {
    var messengerState = ScaffoldMessenger.of(context);
    var repository = await SpeciesHTTPRepository.create();

    if (!await repository.unfavoriteSpecies(species.id!)) {
      messengerState.showSnackBar(const SnackBar(
          content: Text('Não foi possível atualizar os favoritos.')));
    }
  }
}
