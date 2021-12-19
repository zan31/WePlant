class Plant {
  final int plantId;
  final String pName;
  final String pLatinName;
  final String pDescription;
  final String pType;
  final String pImage;
  final bool pFavourite;

  Plant({
    required this.plantId,
    required this.pName,
    required this.pLatinName,
    required this.pDescription,
    required this.pType,
    required this.pImage,
    required this.pFavourite,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantId: json['plantId'],
      pName: json['pName'],
      pLatinName: json['pLatinName'],
      pDescription: json['pDescription'],
      pType: json['pType'],
      pImage: json['pImage'],
      pFavourite: json['pFavourite'],
    );
  }
}
