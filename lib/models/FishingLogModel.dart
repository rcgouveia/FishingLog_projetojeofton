class FishingModel{
  String? id;
  String fishName;
  String photoPath;
  String location;
  DateTime date;
  String? bait;
  String? size;
  String? weight;

  FishingModel({
    this.id,
    required this.fishName,
    required this.photoPath,
    required this.location,
    required this.date,
    this.bait,
    this.size,
    this.weight,
  });
}

