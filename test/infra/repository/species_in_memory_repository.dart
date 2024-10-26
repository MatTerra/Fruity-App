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

  @override
  Future<bool> approveSpecies(Species species) {
    // TODO: implement approveSpecies
    throw UnimplementedError();
  }

  @override
  Future<bool> denySpecies(Species species) {
    // TODO: implement denySpecies
    throw UnimplementedError();
  }

  @override
  Future<List<Species>> getPendingSpecies() {
    // TODO: implement getPendingSpecies
    throw UnimplementedError();
  }

  @override
  Future<List<Species>> getUserProposalsSpecies() {
    // TODO: implement getUserProposalsSpecies
    throw UnimplementedError();
  }

  @override
  Future<List<Species>> getSpeciesByPopularName(String popularName) {
    // TODO: implement getSpeciesByPopularName
    throw UnimplementedError();
  }
}
