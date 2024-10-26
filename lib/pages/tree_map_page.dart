import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fruity/app/components/fruity_drawer.dart';
import 'package:fruity/app/components/location_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fruity/app/components/fruity_app_bar.dart';

import 'package:fruity/domain/repository/Tree_repository.dart';

import 'package:fruity/infra/repository/tree_http_repository.dart';

class TreeMapPage extends StatefulWidget {
  const TreeMapPage({Key? key}) : super(key: key);

  @override
  State<TreeMapPage> createState() => _TreeMapPageState();
}

class _TreeMapPageState extends State<TreeMapPage> with LocationHandler {
  final Map<String, Marker> _trees = {};
  Completer<GoogleMapController> controller1 = Completer();
  static LatLng? _initialPosition;
  String role = '';
  late User? user = FirebaseAuth.instance.currentUser;
  late TreeRepository repository;

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      controller1.complete(controller);
    });
  }

  Future<void> _update() async {
    var token = await user?.getIdTokenResult();
    setState(() {
      role = token?.claims?['role'];
    });
  }

  @override
  void initState() {
    super.initState();
    _update();
    _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    var repositoryFuture = TreeHTTPRepository.create();
    var position = await getCurrentPosition();

    try {
      var trees = await (await repositoryFuture)
          .getTreesNear(LatLng(position.latitude, position.longitude));
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _trees.clear();
        for (final tree in trees) {
          final marker = Marker(
              markerId: MarkerId(tree.id!),
              position: tree.location,
              infoWindow: InfoWindow(
                  title: tree.species.popularNames?.join(','),
                  snippet: tree.producing! ? "Produzindo" : "Sem frutos"));
          _trees[tree.id!] = marker;
        }
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Ocorreu um erro ao carregar as árvores, tente novamente.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FruityDrawer(user: user, role: role),
      appBar: FruityAppBar("Árvores"),
      // floatingActionButton: ,
      body: _initialPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: _initialPosition!, zoom: 15.0),
              markers: _trees.values.toSet(),
            ),
    );
  }
}
