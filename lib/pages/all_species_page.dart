import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fruity/app/components/fruity_drawer.dart';
import 'package:fruity/app/components/species_list_item.dart';
import 'package:fruity/app/components/species_list_item_loader.dart';
import 'package:fruity/domain/repository/species_repository.dart';
import 'package:fruity/infra/repository/species_http_repository.dart';
import 'package:fruity/app/components/propose_species_button.dart';

import '../app/components/fruity_app_bar.dart';
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
    setState(() {
      species = [];
    });
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
        drawer: FruityDrawer(user: user, role: role),
        appBar: FruityAppBar(widget.title),
        body: RefreshIndicator(
          onRefresh: update,
          child: ListView(
              children: species.isNotEmpty
                  ? <Widget>[
                      ...species.map(
                        (specie) => SpeciesListItem(species: specie),
                      ),
                    ]
                  : List.filled(10, const SpeciesListItemLoader())),
        ),
        floatingActionButton: ProposeSpeciesButton());
  }
}
