import 'package:fruity/domain/entities/species.dart';

abstract class SpeciesRepository {
  Species? getSpecies(String id);
}
