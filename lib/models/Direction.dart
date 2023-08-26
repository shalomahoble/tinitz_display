// ignore_for_file: public_member_api_docs, sort_constructors_first
class Direction {
  int? id;
  String libelle;
  String? adresse;
  String image;
  int statut;

  Direction({
    this.id,
    required this.libelle,
    required this.adresse,
    required this.image,
    required this.statut,
  });

  factory Direction.fromJson(Map<String, dynamic> json) => Direction(
        id: json["id"],
        libelle: json["libelle"],
        adresse: json["adresse"],
        image: json["image"],
        statut: json["statut"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "adresse": adresse,
        "image": image,
        "statut": statut,
      };

  @override
  String toString() {
    return 'Direction(id: $id, libelle: $libelle, adresse: $adresse,  image: $image, statut: $statut)';
  }
}
