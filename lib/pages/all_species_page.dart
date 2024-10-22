import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fruity/app/components/fruity_drawer.dart';
import 'package:fruity/app/components/species_list_item.dart';
import 'package:fruity/app/components/species_list_item_loader.dart';
import 'package:fruity/domain/repository/species_repository.dart';
import 'package:fruity/infra/repository/species_http_repository.dart';
import 'package:fruity/app/components/propose_species_button.dart';

import 'package:fruity/app/components/fruity_app_bar.dart';
import 'package:fruity/domain/entities/species.dart';

class AllSpeciesPage extends StatefulWidget {
  bool pending;
  bool mine;

  AllSpeciesPage({Key? key, this.pending = false, this.mine = false})
      : super(key: key);

  String title = "Espécies";

  @override
  _AllSpeciesPageState createState() => _AllSpeciesPageState();
}

class _AllSpeciesPageState extends State<AllSpeciesPage> {
  List<Species>? species;
  late SpeciesRepository repository;
  String role = '';
  late User? user = FirebaseAuth.instance.currentUser;
  bool loading = true;

  Future<void> update() async {
    setState(() {
      species = [];
      loading = true;
    });
    var speciesFromRemote;
    try {
      speciesFromRemote = widget.mine
          ? await repository.getUserProposalsSpecies()
          : widget.pending
              ? await repository.getPendingSpecies()
              : await repository.getAllSpecies();
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Ocorreu um erro ao listar as espécies.")));
    }
    user
        ?.getIdTokenResult()
        .then((token) => setState(() {
              loading = false;
              species = speciesFromRemote;
              role = token.claims?['role'];
            }))
        .catchError((err) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.mine) {
      widget.pending = false;
      widget.title = "Minhas Espécies";
    }
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
              children: loading
                  ? List.filled(10, const SpeciesListItemLoader())
                  : species != null && species!.isNotEmpty
                      ? <Widget>[
                          ...species!.map(
                            (specie) => SpeciesListItem(species: specie),
                          ),
                        ]
                      : <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    species == null
                                        ? "Não foi possível listar as espécies."
                                        : "Não há espécies para listar.",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          )
                        ],
            )),
        floatingActionButton: ProposeSpeciesButton());
  }
}
