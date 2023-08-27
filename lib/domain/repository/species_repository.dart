import 'package:fruity/domain/entities/species.dart';

abstract class SpeciesRepository {
  Future<Species?> getSpecies(String id);
  Future<List<Species>> getAllSpecies();
  Future<List<Species>> getPendingSpecies();
  Future<Species> createSpecies(Species species);
  Future<bool> approveSpecies(Species species);
  Future<bool> denySpecies(Species species);
}
