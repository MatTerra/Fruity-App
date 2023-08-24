import 'package:fruity/domain/entities/species.dart';
import 'package:fruity/domain/repository/species_repository.dart';

class SpeciesInMemoryRepository implements SpeciesRepository {
  final List<Species> species = <Species>[];
  final List<String> calls = <String>[];

  @override
  Future<Species?> getSpecies(String id) {
    calls.add("getSpecies($id)");
    return Future(() => species
        .cast<Species?>()
        .firstWhere((element) => element!.id == id, orElse: () => null));
  }

  Future<Species> createSpecies(Species speciesToAdd) {
    species.add(speciesToAdd);
    return Future(() => speciesToAdd);
  }

  @override
  Future<List<Species>> getAllSpecies() {
    return Future(() => species);
  }
}
