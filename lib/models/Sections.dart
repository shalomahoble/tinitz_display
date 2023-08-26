// ignore_for_file: public_member_api_docs, sort_constructors_first
class Section {
  int? id;
  String? libelle;
  String? fileUrl;
  int? slideId;
  int? typeContenuId;
  String? section;
  DateTime? createdAt;
  DateTime? updatedAt;
  Typecontenu? typecontenu;

  Section({
    this.id,
    this.libelle,
    this.fileUrl,
    this.slideId,
    this.typeContenuId,
    this.section,
    this.createdAt,
    this.updatedAt,
    this.typecontenu,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: json["id"],
        libelle: json["libelle"],
        fileUrl: json["file_url"],
        slideId: json["slide_id"],
        typeContenuId: json["type_contenu_id"],
        section: json["section"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        typecontenu: json["typecontenu"] == null
            ? null
            : Typecontenu.fromJson(json["typecontenu"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "file_url": fileUrl,
        "slide_id": slideId,
        "type_contenu_id": typeContenuId,
        "section": section,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "typecontenu": typecontenu?.toJson(),
      };

  @override
  String toString() {
    return 'Section(id: $id, libelle: $libelle, fileUrl: $fileUrl, slideId: $slideId, typeContenuId: $typeContenuId, section: $section, createdAt: $createdAt, updatedAt: $updatedAt, typecontenu: $typecontenu)';
  }
}

class Typecontenu {
  int? id;
  String? libelle;
  DateTime? createdAt;
  DateTime? updatedAt;

  Typecontenu({
    this.id,
    this.libelle,
    this.createdAt,
    this.updatedAt,
  });

  factory Typecontenu.fromJson(Map<String, dynamic> json) => Typecontenu(
        id: json["id"],
        libelle: json["libelle"],
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'Typecontenu(id: $id, libelle: $libelle, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
