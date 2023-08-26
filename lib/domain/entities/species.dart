class Species {
  String? id;
  String creator;
  String scientificName;
  List<String>? popularNames;
  String? description;
  List<String>? links;
  List<String>? picturesUrl;
  int? seasonStartMonth;
  int? seasonEndMonth;

  Species({this.id,
    required this.creator,
    required this.scientificName,
    this.popularNames,
    this.description,
    this.links,
    this.picturesUrl,
    this.seasonStartMonth,
    this.seasonEndMonth});

  Species.fromJson(Map<String, dynamic> json)
      : id = json['id_'],
        creator = json['creator'],
        scientificName = formatName(json['scientific_name']),
        popularNames =
        List<String>.from(json['popular_names']).map(formatName).toList(),
        description = json['description'],
        links = List<String>.from(json['links']),
        picturesUrl = List<String>.from(json['pictures_url']),
        seasonStartMonth = json['season_start_month'],
        seasonEndMonth = json['season_end_month'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'creator': creator,
      'scientific_name': scientificName,
      'popular_names': popularNames ?? [],
      'description': description ?? '',
      'links': links ?? [],
      'pictures_url': picturesUrl ?? [],
    };

    if (id != null) {
      json.addAll({'id_': id});
    }
    if (seasonStartMonth != null) {
      json.addAll({'season_start_month': seasonStartMonth});
    }
    if (seasonEndMonth != null) {
      json.addAll({'season_end_month': seasonEndMonth});
    }
    return json;
  }

  static String formatName(String name) =>
      name.isNotEmpty ? "${name[0].toUpperCase()}${name.substring(1)}" : "";
}
