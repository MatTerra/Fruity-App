import 'package:flutter/material.dart';
import 'package:fruity/app/components/species_list_item.dart';
import 'package:fruity/domain/entities/species.dart';
import 'package:fruity/infra/repository/species_http_repository.dart';

class SpeciesSearchDelegate extends SearchDelegate<Species?> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => Container();

  Future<List<Species>> search(String query) async {
    var repository = await SpeciesHTTPRepository.create();
    return repository.getSpeciesByPopularName(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return const Center(child: Text("Comece a digitar para pesquisar"));
    }
    final searchFuture = search(query);
    return FutureBuilder(
        future: searchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data != null){
              final list = snapshot.data as List<Species>;
              if (list.isNotEmpty) {
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SpeciesListItem(species: list[index]);
                    });
              }
              return const Center(child: Text("Nenhuma espécie encontrada."));
            }
            return const Center(child: Text("Nenhuma espécie encontrada."));
          }
          return const LinearProgressIndicator();
        });
  }
}
