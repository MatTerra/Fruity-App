import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:fruity/domain/entities/tree.dart';

abstract class TreeRepository {
  Future<Tree?> getTree(String id);
  Future<List<Tree>> getTreesNear(LatLng origin, bool? producing);
  Future<Tree> createTree(Tree tree);
}
