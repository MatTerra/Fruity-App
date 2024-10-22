import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

mixin LocationHandler<T extends StatefulWidget> on State<T> {
  Future<Position?> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return null;
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'A localização está desabilitada, por favor habilite.')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foi negada a permissão de localização.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'As permissões de localização foram negadas permanentemente.')));
      return false;
    }
    return true;
  }
}
