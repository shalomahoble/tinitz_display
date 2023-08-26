// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:borne_flutter/models/Direction.dart';

class Site {
  int? id;
  String? libelle;
  String? adresse;
  String? ville;
  String? contact;
  String? email;
  int? statut;
  String image;
  int? directionId;
  String? timezone;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Direction direction;

  Site({
    this.id,
    this.libelle,
    this.adresse,
    this.ville,
    this.contact,
    this.email,
    this.statut,
    required this.image,
    this.directionId,
    this.timezone,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    required this.direction,
  });

 

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        id: json["id"],
        libelle: json["libelle"],
        adresse: json["adresse"],
        ville: json["ville"],
        contact: json["contact"],
        email: json["email"],
        statut: json["statut"],
        image: json["image"],
        directionId: json["direction_id"],
        timezone: json["timezone"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        direction: Direction.fromJson(json["direction"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "adresse": adresse,
        "ville": ville,
        "contact": contact,
        "email": email,
        "statut": statut,
        "image": image,
        "direction_id": directionId,
        "timezone": timezone,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "direction": direction.toJson(),
      };

  @override
  String toString() {
    return 'Site(id: $id, libelle: $libelle, adresse: $adresse, ville: $ville, contact: $contact, email: $email, statut: $statut, image: $image, directionId: $directionId, timezone: $timezone, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt Direction: )';
  }
}
