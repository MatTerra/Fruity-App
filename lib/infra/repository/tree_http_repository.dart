import 'dart:convert';

import 'package:fruity/domain/entities/tree.dart';
import 'package:fruity/domain/repository/tree_repository.dart';
import 'package:fruity/infra/service/default_http_service.dart';
import 'package:fruity/infra/service/http_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TreeHTTPRepository implements TreeRepository {
  late HTTPService httpService;

  TreeHTTPRepository._create();

  static Future<TreeHTTPRepository> create() async {
    var repository = TreeHTTPRepository._create();
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
  Future<Tree?> getTree(String id) {
    return Future(() => null);
  }

  @override
  Future<List<Tree>> getTreesNear(LatLng origin, {bool? producing}) async {
    List<dynamic> treeList = (await httpService.get(
            "/v1/tree?location=[${origin.longitude},${origin.latitude}]${producing != null ? '&producing=$producing' : ''}")
        as List)[1] as List;

    return treeList.map((s) => Tree.fromJson(s)).toList();
  }

  @override
  Future<Tree> createTree(Tree tree) async {
    tree.id = await httpService.post("/v1/tree", jsonEncode(tree));

    return tree;
  }
}
