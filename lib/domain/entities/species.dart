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
}
