import 'package:fruity/domain/entities/species.dart';

abstract class SpeciesRepository {
  Future<Species?> getSpecies(String id);
  Future<List<Species>> getAllSpecies();
  Future<List<Species>> getPendingSpecies();
  Future<List<Species>> getUserProposalsSpecies();
  Future<List<Species>> getSpeciesByPopularName(String popularName);
  Future<Species> createSpecies(Species species);
  Future<bool> approveSpecies(Species species);
  Future<bool> denySpecies(Species species);
  Future<bool> favoriteSpecies(String id);
  Future<bool> unfavoriteSpecies(String id);
}
