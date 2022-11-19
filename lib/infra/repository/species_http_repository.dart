import 'package:fruity/domain/repository/species_repository.dart';

import '../../domain/entities/species.dart';

class SpeciesHTTPRepository implements SpeciesRepository{
  @override
  Species? getSpecies(String id){
    return null;
  }

  Species _createSpeciesFromJson(Map<String, dynamic> json){
    return Species(id: '', creator: '', scientificName: '');
  }
}