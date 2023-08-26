// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final borne = borneFromJson(jsonString);

import 'dart:convert';

import 'package:borne_flutter/models/Alerte.dart';
import 'package:borne_flutter/models/Artcile.dart';
import 'package:borne_flutter/models/Site.dart';
import 'package:borne_flutter/models/Slide.dart';

Borne borneFromJson(String str) => Borne.fromJson(json.decode(str));

String borneToJson(Borne data) => json.encode(data.toJson());

class Borne {
  int? id;
  String? code;
  String? password;
  String? libelle;
  String? adresse;
  String? adresseip;
  int? statut;
  int? siteId;
  dynamic token;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Site? site;
  List<Slide>? slides;
  List<Article>? articles;
  List<Alert>? alerts;

  Borne({
    this.id,
    this.code,
    this.password,
    this.libelle,
    this.adresse,
    this.adresseip,
    this.statut,
    this.siteId,
    this.token,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.site,
    this.slides,
    this.articles,
    this.alerts,
  });

  factory Borne.fromJson(Map<String, dynamic> json) => Borne(
        id: json["id"],
        code: json["code"],
        password: json["password"],
        libelle: json["libelle"],
        adresse: json["adresse"],
        adresseip: json["adresseip"],
        statut: json["statut"],
        siteId: json["site_id"],
        token: json["token"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        site: json["site"] == null ? null : Site.fromJson(json["site"]),
        slides: json["slides"] == null
            ? []
            : List<Slide>.from(json["slides"]!.map((x) => Slide.fromJson(x))),
        articles: json["articles"] == null
            ? []
            : List<Article>.from(
                json["articles"]!.map((x) => Article.fromJson(x))),
        alerts: json["alerts"] == null
            ? []
            : List<Alert>.from(json["alerts"]!.map((x) => Alert.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "password": password,
        "libelle": libelle,
        "adresse": adresse,
        "adresseip": adresseip,
        "statut": statut,
        "site_id": siteId,
        "token": token,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "site": site?.toJson(),
        /*   "slides": slides == null
            ? []
            : List<dynamic>.from(slides!.map((x) => x.toJson())),
        "articles": articles == null
            ? []
            : List<dynamic>.from(articles!.map((x) => x.toJson())),
        "alerts": alerts == null
            ? []
            : List<dynamic>.from(alerts!.map((x) => x.toJson())), */
      };

  @override
  String toString() {
    return 'Borne(id: $id, code: $code, password: $password, libelle: $libelle, adresse: $adresse, adresseip: $adresseip, statut: $statut, siteId: $siteId, token: $token, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt,)';
  }
}
