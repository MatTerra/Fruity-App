import 'package:fruity/domain/entities/species.dart';
import 'package:fruity/domain/repository/species_repository.dart';

class SpeciesInMemoryRepository implements SpeciesRepository {
  final List<Species> species = <Species>[];
  final List<String> calls = <String>[];

  @override
  Species? getSpecies(String id) {
    calls.add("getSpecies($id)");
    return species
        .cast<Species?>()
        .firstWhere((element) => element!.id == id, orElse: () => null);
  }

  void createSpecies(Species speciesToAdd){
    species.add(speciesToAdd);
  }
}
