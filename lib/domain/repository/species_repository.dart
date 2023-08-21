import 'package:fruity/domain/entities/species.dart';

abstract class SpeciesRepository {
  Future<Species?> getSpecies(String id);
  Future<List<Species>> getAllSpecies();
}
