import 'package:fruity/domain/repository/species_repository.dart';
import 'package:fruity/infra/service/default_http_service.dart';
import 'package:fruity/infra/service/http_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/species.dart';

class SpeciesHTTPRepository implements SpeciesRepository{
  late HTTPService httpService;

  SpeciesHTTPRepository._create();

  static Future<SpeciesHTTPRepository> create() async{
    var repository = SpeciesHTTPRepository._create();
    var token = (await FirebaseAuth.instance.currentUser?.getIdToken())!;
    repository.httpService = DefaultHTTPService(
        "http://10.0.2.2:8000",
        defaultHeaders: {'Authentication': 'Bearer $token'}
    );
    return repository;
  }

  @override
  Future<Species?> getSpecies(String id){
    return Future(() => null);
  }

  @override
  Future<List<Species>> getAllSpecies() async {
    List<dynamic> speciesList = (await httpService.get("/v1/species") as List)[1] as List;

    return speciesList.map((s) => Species.fromJson(s)).toList();
  }
}