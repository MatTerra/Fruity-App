import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruity/domain/repository/species_repository.dart';
import 'package:fruity/infra/repository/species_http_repository.dart';
import 'package:fruity/pages/propose_species.dart';
import 'package:fruity/pages/species_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app/components/fruityAppBar.dart';
import '../domain/entities/species.dart';

class AllSpeciesPage extends StatefulWidget {
  bool pending;

  AllSpeciesPage({Key? key, this.pending = false}) : super(key: key);

  String title = "Espécies";

  @override
  _AllSpeciesPageState createState() => _AllSpeciesPageState();
}

class _AllSpeciesPageState extends State<AllSpeciesPage> {
  List<Species> species = [];
  late SpeciesRepository repository;
  String role = '';
  late User? user = FirebaseAuth.instance.currentUser;

  Future<void> update() async {
    var speciesFromRemote = widget.pending
        ? await repository.getPendingSpecies()
        : await repository.getAllSpecies();
    user?.getIdTokenResult().then((token) => setState(() {
          species = speciesFromRemote;
          role = token.claims?['role'];
        }));
  }

  @override
  void initState() {
    super.initState();
    if (widget.pending) {
      widget.title += " Pendentes";
    }

    SpeciesHTTPRepository.create().then((repository) {
      this.repository = repository;
      update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Column(
                  children: [
                    Expanded(
                      child: UserAvatar(
                        auth: FirebaseAuth.instance,
                      ),
                    ),
                    Text(user?.displayName ?? user?.email ?? '')
                  ],
                ),
              ),
              ListTile(
                title: const Text('Espécies'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AllSpeciesPage(pending: false)));
                },
              ),
              role == 'admin'
                  ? ListTile(
                      title: const Text('Espécies pendentes'),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllSpeciesPage(
                                      pending: true,
                                    )));
                      },
                    )
                  : Container()
            ],
          ),
        ),
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
                            builder: (context) => SpeciesDetailPage(
                                species: specie, pending: widget.pending)));
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProposeSpeciesPage()));
          },
          tooltip: 'Propor nova espécie',
          child: const Icon(Icons.add),
        ));
  }
}
