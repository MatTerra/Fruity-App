import 'dart:convert';

import 'package:fruity/domain/entities/species.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tree {
  String? id;
  String creator;
  Species species;
  String? variety;
  LatLng location;
  String? description;
  bool? producing;
  List<String>? pictures_url;
  static Utf8Decoder utf8Decoder = const Utf8Decoder();

  Tree(
      {this.id,
      required this.creator,
      required this.species,
      this.variety,
      required this.location,
      this.description,
      this.producing,
      this.pictures_url});

  Tree.fromJson(Map<String, dynamic> json)
  : id = json['id_'],
  creator = json['creator'],
  species = Species.fromJson(json['species']),
  variety = utf8Decoder.convert(json['variety'].codeUnits),
  location = LatLng(json['location'][1], json['location'][0]),
  description = utf8Decoder.convert(json['description'].codeUnits),
  producing = json['producing'],
  pictures_url = List<String>.from(json['pictures_url']);

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = {
      'creator': creator,
      'species': species.toJson(),
      'location': [location.longitude, location.latitude],
      'description': description ?? '',
      'producing': producing ?? false,
      'pictures_url': pictures_url ?? [],
    };
    if (id != null) {
      json.addAll({'id_': id});
    }
    if (variety != null) {
      json.addAll({'variety': variety});
    }
    return json;
  }
}
