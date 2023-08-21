class Species {
  String id;
  String creator;
  String scientificName;
  List<String>? popularNames;
  String? description;
  List<String>? links;
  List<String>? picturesUrl;
  int? seasonStartMonth;
  int? seasonEndMonth;

  Species(
      {required this.id,
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
        popularNames = List<String>.from(json['popular_names']).map(formatName).toList(),
        description = json['description'],
        links = List<String>.from(json['links']),
        picturesUrl = List<String>.from(json['pictures_url']),
        seasonStartMonth = json['season_start_month'],
        seasonEndMonth = json['season_end_month'];


  static String formatName(name) => "${name[0].toUpperCase()}${name.substring(1)}";
}
