import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruity/domain/repository/species_repository.dart';
import 'package:fruity/infra/repository/species_http_repository.dart';
import 'package:fruity/pages/propose_species.dart';
import 'package:fruity/pages/species_detail_page.dart';

import '../app/components/fruityAppBar.dart';
import '../domain/entities/species.dart';

class AllSpeciesPage extends StatefulWidget {
  AllSpeciesPage({
    Key? key,
  }) : super(key: key);

  final String title = "Espécies";

  @override
  _AllSpeciesPageState createState() => _AllSpeciesPageState();
}

class _AllSpeciesPageState extends State<AllSpeciesPage> {
  List<Species> species = [];
  late SpeciesRepository repository;

  Future<void> update() async {
    var speciesFromRemote = await repository.getAllSpecies();
    setState(() {
      species = speciesFromRemote;
    });
  }

  @override
  void initState() {
    super.initState();

    SpeciesHTTPRepository.create().then((repository) {
      this.repository = repository;
      update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: FruityAppBar(widget.title),
        body: RefreshIndicator(
          onRefresh: update,
          child: ListView(children: <Widget>[
            ...species.map(
              (specie) => ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SpeciesDetailPage(species: specie)));
                  },
                  leading: Container(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundImage: specie.picturesUrl!.isNotEmpty
                          ? NetworkImage(specie.picturesUrl![0])
                          : AssetImage('assets/tree-silhouette.png')
                              as ImageProvider,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(specie.scientificName,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                      Text(specie.popularNames!.join(", ")),
                      const SizedBox(
                        height: 7,
                      )
                    ],
                  ),
                  subtitle: Text(
                    specie.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProposeSpeciesPage()));
          },
          tooltip: 'Propor nova espécie',
          child: const Icon(Icons.add),
        ));
  }
}
