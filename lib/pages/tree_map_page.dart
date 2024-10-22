import 'package:flutter/material.dart';
import 'package:fruity/app/components/fruity_drawer.dart';
import 'package:fruity/app/components/location_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fruity/app/components/fruity_app_bar.dart';

import 'package:fruity/domain/repository/Tree_repository.dart';

import 'package:fruity/infra/repository/tree_http_repository.dart';

class TreeMapPage extends StatefulWidget {
  const TreeMapPage({Key? key}) : super(key: key);

  @override
  _TreeMapPageState createState() => _TreeMapPageState();
}

class _TreeMapPageState extends State<TreeMapPage> with LocationHandler {
  final Map<String, Marker> _trees = {};
  Position? _currentPosition;
  late GoogleMapController mapController;
  String role = '';
  late User? user = FirebaseAuth.instance.currentUser;
  late TreeRepository repository;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    var updateFuture = _update();
    await updateFuture;
    var repository = await TreeHTTPRepository.create();
    try {
      var trees = await repository.getTreesNear(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
      setState(() {
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
    } catch (err){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Ocorreu um erro ao carregar as árvores, tente novamente.')));
    }
  }

  Future<void> _update() async {
    var futurePosition = getCurrentPosition();
    var token = await user?.getIdTokenResult();
    var position = await futurePosition;
    setState(() {
      role = token?.claims?['role'];
      _currentPosition = position;
    });
  }

  @override
  void initState() {
    getCurrentPosition().then((value) => setState(() {
      _currentPosition = value;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FruityDrawer(user: user, role: role),
      appBar: FruityAppBar("Árvores"),
      // floatingActionButton: ,
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(_currentPosition?.latitude ?? -15.79082045623587,
                _currentPosition?.longitude ?? -47.86114020307252),
            zoom: 15.0),
        markers: _trees.values.toSet(),
      ),
    );
  }
}
