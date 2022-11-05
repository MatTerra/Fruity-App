import 'package:flutter_test/flutter_test.dart';
import 'package:fruity/domain/entities/species.dart';
import 'package:fruity/domain/use_cases/get_species.dart';

import '../../infra/repository/species_in_memory_repository.dart';

void main() {
  test('Should call the repository', () {
    final input = GetSpeciesInput('some_id');
    var repository = SpeciesInMemoryRepository();
    final useCase = GetSpecies(repository);

    final output = useCase.execute(input);
    expect(repository.calls.length, 1);
    expect(repository.calls[0], "getSpecies(some_id)");
    expect(output.species, null);
  });

  test('Should return species if found in repository', () {
    final input = GetSpeciesInput('some_id');
    var repository = SpeciesInMemoryRepository();
    var testSpecies = Species(
        id: 'some_id',
        creator: 'tester',
        scientificName: 'scientificus_nomus');
    repository.createSpecies(testSpecies);

    final useCase = GetSpecies(repository);

    final output = useCase.execute(input);
    expect(repository.calls.length, 1);
    expect(repository.calls[0], "getSpecies(some_id)");
    expect(output.species, testSpecies);
  });
}
