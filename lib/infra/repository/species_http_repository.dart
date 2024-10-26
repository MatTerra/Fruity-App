import 'dart:convert';

import 'package:fruity/domain/repository/species_repository.dart';
import 'package:fruity/infra/service/default_http_service.dart';
import 'package:fruity/infra/service/http_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/species.dart';

class SpeciesHTTPRepository implements SpeciesRepository {
  late HTTPService httpService;

  SpeciesHTTPRepository._create();

  static Future<SpeciesHTTPRepository> create() async {
    var repository = SpeciesHTTPRepository._create();
    var token = (await FirebaseAuth.instance.currentUser?.getIdToken())!;
    repository.httpService = DefaultHTTPService(
        "https://fruity-api.matterra.com.br",
        defaultHeaders: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'User-Agent': 'FruityApp'
        });
    return repository;
  }

  @override
  Future<Species?> getSpecies(String id) {
    return Future(() => null);
  }

  @override
  Future<List<Species>> getAllSpecies() async {
    List<dynamic> speciesList =
        (await httpService.get("/v1/species") as List)[1] as List;

    return speciesList.map((s) => Species.fromJson(s)).toList();
  }

  @override
  Future<List<Species>> getPendingSpecies() async {
    List<dynamic> speciesList =
    (await httpService.get("/v1/species/pending") as List)[1] as List;

    return speciesList.map((s) => Species.fromJson(s)).toList();
  }

  @override
  Future<List<Species>> getUserProposalsSpecies() async {
    List<dynamic> speciesList =
    (await httpService.get("/v1/species/my-species") as List)[1] as List;

    return speciesList.map((s) => Species.fromJson(s)).toList();
  }

  @override
  Future<Species> createSpecies(Species species) async {
    species.id = await httpService.post("/v1/species", jsonEncode(species));

    return species;
  }

  @override
  Future<bool> approveSpecies(Species species) async {
    await httpService.post("/v1/species/${species.id}/approve", "");
    return true;
  }

  @override
  Future<bool> denySpecies(Species species) async {
    await httpService.post("/v1/species/${species.id}/deny", "");
    return true;
  }

  @override
  Future<List<Species>> getSpeciesByPopularName(String popularName) async {
    List<dynamic> speciesList =
    (await httpService.get("/v1/species", query: {"popular_name": popularName}) as List)[1] as List;

    return speciesList.map((s) => Species.fromJson(s)).toList();
  }


}
