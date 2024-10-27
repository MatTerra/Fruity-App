import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fruity/app/components/create_tree_button.dart';
import 'package:fruity/domain/entities/species.dart';
import 'package:fruity/infra/repository/species_http_repository.dart';
import 'package:fruity/app/components/field_with_title.dart';

import 'all_species_page.dart';

class SpeciesDetailPage extends StatelessWidget {
  final Species species;
  final ValueNotifier<bool> loading = ValueNotifier(false);

  String toMonthName(month) {
    const months = [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro"
    ];
    return months[month - 1];
  }

  SpeciesDetailPage({Key? key, required this.species}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = "Temporada";
    var content =
        "De ${toMonthName(species.seasonStartMonth!)} à ${toMonthName(species.seasonEndMonth!)}";
    return ValueListenableBuilder(
        valueListenable: loading,
        builder: (context, isLoading, child) {
          return Scaffold(
            floatingActionButton: CreateTreeButton(
              species: species,
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          species.favorite ?? false ? _unfavoriteSpecies(context) : _favoriteSpecies(context);
                        },
                        icon: Icon(species.favorite ?? false ? Icons.favorite : Icons.favorite_border)),
                  ],
                  title: Text(
                    species.scientificName,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  expandedHeight: 350.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ShaderMask(
                      shaderCallback: (bound) {
                        return LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.black54.withOpacity(0.80),
                              Colors.transparent
                            ],
                            stops: const [
                              0.0,
                              0.22
                            ]).createShader(bound);
                      },
                      blendMode: BlendMode.srcOver,
                      child: species.picturesUrl!.isNotEmpty
                          ? Swiper(
                              itemBuilder: (context, index) {
                                final image = species.picturesUrl![index];
                                return Image.network(
                                  image,
                                  fit: BoxFit.fitWidth,
                                );
                              },
                              indicatorLayout: PageIndicatorLayout.COLOR,
                              autoplay: true,
                              itemCount: species.picturesUrl!.length,
                              pagination: const SwiperPagination(),
                              control: const SwiperControl(),
                            )
                          : Image.asset('assets/tree-silhouette.png',
                              fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  species.approved ?? true
                      ? Container()
                      : const SizedBox(
                          height: 20,
                          child: Material(
                            color: Colors.red,
                            child: Center(
                                child: Text(
                              "Aguardando aprovação!",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            )),
                          )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(species.popularNames!.join(", "),
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ),
                  FieldWithTitle(title: title, content: content),
                  FieldWithTitle(
                      title: "Sobre", content: species.description ?? ""),
                  species.approved ?? true
                      ? Container()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                _approveSpecies(context, true);
                              },
                              child: isLoading as bool
                                  ? const CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 3,
                                    )
                                  : const Text("Aprovar"),
                            ),
                            MaterialButton(
                              onPressed: () {
                                _approveSpecies(context, false);
                              },
                              child: isLoading as bool
                                  ? const CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 3,
                                    )
                                  : const Text("Negar"),
                            )
                          ],
                        )
                ]))
              ],
            ),
          );
        });
  }

  void _approveSpecies(BuildContext context, bool approve) async {
    var messengerState = ScaffoldMessenger.of(context);
    var navigator = Navigator.of(context);
    var repository = await SpeciesHTTPRepository.create();
    bool result;
    if (approve) {
      result = await repository.approveSpecies(species);
    } else {
      result = await repository.denySpecies(species);
    }
    if (result) {
      navigator.pushReplacement(MaterialPageRoute(
          builder: (context) => AllSpeciesPage(pending: !approve)));
    } else {
      messengerState.showSnackBar(const SnackBar(
          content: Text('Não foi possível atualizar a espécie.')));
    }
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
