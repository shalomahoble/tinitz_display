// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:borne_flutter/models/Event.dart';
import 'package:borne_flutter/models/Partenaire.dart';
import 'package:borne_flutter/models/sections.dart';

class Slide {
  int? id;
  String? titre;
  String? description;
  String? bg;
  String bgType;
  String cible;
  String? urlQrCode;
  int duree;
  int? statut;
  String? qrcode;
  int? typeQrcodeSecondId;
  String? createdBy;
  int? typeSlideId;
  int? partenaireId;
  int? eventId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? qrcodeSecond;
  String? descQrcodeFirst;
  String? descQrcodeSecond;
  SlidePivot? pivot;
  Partenaire? partenaire;
  Event? event;
  Typeslide? typeslide;
  Typeqrcode? typeqrcode;
  List<Section>? sections;

  Slide({
    this.id,
    this.titre,
    this.description,
    this.bg,
    required this.bgType,
    required this.cible,
    this.urlQrCode,
    required this.duree,
    this.statut,
    this.qrcode,
    this.typeQrcodeSecondId,
    this.createdBy,
    this.typeSlideId,
    this.partenaireId,
    this.eventId,
    this.createdAt,
    this.updatedAt,
    this.qrcodeSecond,
    this.descQrcodeFirst,
    this.descQrcodeSecond,
    this.pivot,
    this.partenaire,
    this.event,
    this.typeslide,
    this.typeqrcode,
    this.sections,
  });

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
        id: json["id"],
        titre: json["titre"],
        description: json["description"],
        bg: json["bg"],
        cible: json["cible"],
        duree: json["duree"],
        urlQrCode: json["url_qrcode"],
        bgType: json["bg_type"],
        statut: json["statut"],
        qrcode: json["qr_code"],
        typeQrcodeSecondId: json["type_qrcode_second_id"],
        createdBy: json["created_by"],
        typeSlideId: json["type_slide_id"],
        partenaireId: json["partenaire_id"],
        eventId: json["event_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        qrcodeSecond: json["qrcode_second"],
        descQrcodeFirst: json["desc_qrcode_first"],
        descQrcodeSecond: json["desc_qrcode_second"],
        pivot:
            json["pivot"] == null ? null : SlidePivot.fromJson(json["pivot"]),
        partenaire: json["partenaire"] == null
            ? null
            : Partenaire.fromJson(json["partenaire"]),
        event: json["event"] == null ? null : Event.fromJson(json["event"]),
        typeslide: json["typeslide"] == null
            ? null
            : Typeslide.fromJson(json["typeslide"]),
        typeqrcode: json["typeqrcode"] == null
            ? null
            : Typeqrcode.fromJson(json["typeqrcode"]),
        sections: json["sections"] == null
            ? []
            : List<Section>.from(
                json["sections"]!.map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "titre": titre,
        "description": description,
        "bg": bg,
        "bg_type": bgType,
        "cible": cible,
        "url_qrcode": urlQrCode,
        "duree": duree,
        "statut": statut,
        "qrcode": qrcode,
        "type_qrcode_second_id": typeQrcodeSecondId,
        "created_by": createdBy,
        "type_slide_id": typeSlideId,
        "partenaire_id": partenaireId,
        "event_id": eventId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "qrcode_second": qrcodeSecond,
        "desc_qrcode_first": descQrcodeFirst,
        "desc_qrcode_second": descQrcodeSecond,
        "pivot": pivot?.toJson(),
        "partenaire": partenaire?.toJson(),
        "event": event?.toJson(),
        "typeslide": typeslide?.toJson(),
        "typeqrcode": typeqrcode?.toJson(),
        "sections": sections == null
            ? []
            : List<dynamic>.from(sections!.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Slide(id: $id, titre: $titre, description: $description, bg: $bg, bgType : $bgType , cible : $cible  , duree : $duree , urlQrCode : $urlQrCode, statut: $statut, qrcode: $qrcode, typeQrcodeSecondId: $typeQrcodeSecondId, createdBy: $createdBy, typeSlideId: $typeSlideId, partenaireId: $partenaireId, eventId: $eventId, createdAt: $createdAt, updatedAt: $updatedAt, qrcodeSecond: $qrcodeSecond, descQrcodeFirst: $descQrcodeFirst, descQrcodeSecond: $descQrcodeSecond, partenaire: $partenaire, event: $event, typeslide: $typeslide, typeqrcode: $typeqrcode, sectons: $sections)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Slide && runtimeType == other.runtimeType && id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => (id.hashCode);
}

class SlidePivot {
  int? borneId;
  int? slideId;

  SlidePivot({
    this.borneId,
    this.slideId,
  });

  factory SlidePivot.fromJson(Map<String, dynamic> json) => SlidePivot(
        borneId: json["borne_id"],
        slideId: json["slide_id"],
      );

  Map<String, dynamic> toJson() => {
        "borne_id": borneId,
        "slide_id": slideId,
      };
}

class Typeslide {
  int? id;
  String? libelle;
  int? statut;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Typeslide({
    this.id,
    this.libelle,
    this.statut,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Typeslide.fromJson(Map<String, dynamic> json) => Typeslide(
        id: json["id"],
        libelle: json["libelle"],
        statut: json["statut"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "statut": statut,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'Typeslide(id: $id, libelle: $libelle, statut: $statut, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class Typeqrcode {
  int? id;
  String? libelle;
  int? statut;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Typeqrcode({
    this.id,
    this.libelle,
    this.statut,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Typeqrcode.fromJson(Map<String, dynamic> json) => Typeqrcode(
        id: json["id"],
        libelle: json["libelle"],
        statut: json["statut"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "statut": statut,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'Typeqrcode(id: $id, libelle: $libelle, statut: $statut, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
