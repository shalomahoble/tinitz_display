// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final setting = settingFromJson(jsonString);

import 'dart:convert';

Setting settingFromJson(String str) => Setting.fromJson(json.decode(str));

String settingToJson(Setting data) => json.encode(data.toJson());

class Setting {
  final int id;
  final String name;
  final String slogan;
  final String phone;
  final String description;
  final String email;
  final String logo;
  final String logoborne;
  final String favicon;
  final String adresse;
  final String facebook;
  final String twitter;
  final String instagram;
  final String map;
  final DateTime createdAt;
  final DateTime updatedAt;

  Setting({
    required this.id,
    required this.name,
    required this.slogan,
    required this.phone,
    required this.description,
    required this.email,
    required this.logo,
    required this.logoborne,
    required this.favicon,
    required this.adresse,
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.map,
    required this.createdAt,
    required this.updatedAt,
  });

  Setting.fromNull(
      this.id,
      this.name,
      this.slogan,
      this.phone,
      this.description,
      this.email,
      this.logo,
      this.logoborne,
      this.favicon,
      this.adresse,
      this.facebook,
      this.twitter,
      this.instagram,
      this.map,
      this.createdAt,
      this.updatedAt);

  Setting copyWith({
    int? id,
    String? name,
    String? slogan,
    String? phone,
    String? description,
    String? email,
    String? logo,
    String? logoborne,
    String? favicon,
    String? adresse,
    String? facebook,
    String? twitter,
    String? instagram,
    String? map,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Setting(
        id: id ?? this.id,
        name: name ?? this.name,
        slogan: slogan ?? this.slogan,
        phone: phone ?? this.phone,
        description: description ?? this.description,
        email: email ?? this.email,
        logo: logo ?? this.logo,
        logoborne: logoborne ?? this.logoborne,
        favicon: favicon ?? this.favicon,
        adresse: adresse ?? this.adresse,
        facebook: facebook ?? this.facebook,
        twitter: twitter ?? this.twitter,
        instagram: instagram ?? this.instagram,
        map: map ?? this.map,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        id: json["id"],
        name: json["name"],
        slogan: json["slogan"],
        phone: json["phone"],
        description: json["description"],
        email: json["email"],
        logo: json["logo"],
        logoborne: json["logoborne"],
        favicon: json["favicon"],
        adresse: json["adresse"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        map: json["map"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slogan": slogan,
        "phone": phone,
        "description": description,
        "email": email,
        "logo": logo,
        "logoborne": logoborne,
        "favicon": favicon,
        "adresse": adresse,
        "facebook": facebook,
        "twitter": twitter,
        "instagram": instagram,
        "map": map,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'Setting(id: $id, name: $name, slogan: $slogan, phone: $phone, description: $description, email: $email, logo: $logo, logoborne: $logoborne, favicon: $favicon, adresse: $adresse, facebook: $facebook, twitter: $twitter, instagram: $instagram, map: $map, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
