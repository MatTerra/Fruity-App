import 'package:flutter/material.dart';
import 'package:fruity/app/components/fruity_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fruity/app/components/fruity_app_bar.dart';

class TreeMapPage extends StatefulWidget {
  const TreeMapPage({Key? key}) : super(key: key);

  @override
  _TreeMapPageState createState() => _TreeMapPageState();
}

class _TreeMapPageState extends State<TreeMapPage> {
  final Map<String, Marker> _trees = {};
  Position? _currentPosition;
  late GoogleMapController mapController;
  String role = '';
  late User? user = FirebaseAuth.instance.currentUser;
  // late TreeRepository repository;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    // TODO: getTrees
    var trees = [];
    setState(() {
      _trees.clear();
      for (final tree in trees) {
        final marker = Marker(
            markerId: MarkerId(tree.id),
            position: LatLng(tree.location[1], tree.location[0]),
            infoWindow: InfoWindow(
                title: tree.species.popularNames[0],
                snippet: tree.producing ? "Produzindo" : "Sem frutos"));
        _trees[tree.id] = marker;
      }
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _update() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    var futurePosition =
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var token = await user?.getIdTokenResult();
    var position = await futurePosition;
    setState(() {
      role = token?.claims?['role'];
      _currentPosition = position;
    });
  }

  @override
  void initState() {
    _update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FruityDrawer(user: user, role: role),
      appBar: FruityAppBar("Árvores"),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(_currentPosition?.latitude ?? -15.79082045623587,
                _currentPosition?.longitude ?? -47.86114020307252),
            zoom: 11.0),
        markers: _trees.values.toSet(),
      ),
    );
  }
}
