import 'dart:convert';

class Caisse {
  final int? id;
  final String libelle;
  final String image;
  final int? siteId;
  final int? directionId;
  final int? serviceId;
  final int? directionuserId;
  final String? createdBy;
  final String? createdAt;
  final dynamic updatedAt;

  Caisse({
    this.id,
    required this.libelle,
    required this.image,
    this.siteId,
    this.directionId,
    this.serviceId,
    this.directionuserId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Caisse.fromRawJson(String str) => Caisse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Caisse.fromJson(Map<String, dynamic> json) => Caisse(
        id: json["id"],
        libelle: json["libelle"],
        image: json["image"],
        siteId: json["site_id"],
        directionId: json["direction_id"],
        serviceId: json["service_id"],
        directionuserId: json["directionuser_id"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "image": image,
        "site_id": siteId,
        "direction_id": directionId,
        "service_id": serviceId,
        "directionuser_id": directionuserId,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
