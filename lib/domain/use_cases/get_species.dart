import 'package:fruity/domain/entities/species.dart';
import 'package:fruity/domain/repository/species_repository.dart';

class GetSpeciesOutput{
  final Species? species;

  GetSpeciesOutput(this.species);
}

class GetSpeciesInput{
  final String id;

  GetSpeciesInput(this.id);
}

class GetSpecies{
  final SpeciesRepository repository;

  GetSpecies(this.repository);

  Future<GetSpeciesOutput> execute(GetSpeciesInput input) async {
    return GetSpeciesOutput(await repository.getSpecies(input.id));
  }
}