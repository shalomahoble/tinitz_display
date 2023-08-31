// ignore_for_file: public_member_api_docs, sort_constructors_first
class Alert {
  int? id;
  int? typeAlertId;
  String libelle;
  dynamic fileUrl;
  String? description;
  int? statut;
  int? permanent;
  int randomVideo;
  DateTime? fin;
  DateTime? debut;
  DateTime? createdAt;
  DateTime? updatedAt;
  AlertPivot? pivot;
  Typealert typealert;

  Alert({
    this.id,
    this.typeAlertId,
    required this.libelle,
    this.fileUrl,
    this.description,
    this.statut,
    this.permanent,
    required this.randomVideo,
    this.debut,
    this.fin,
    this.createdAt,
    this.updatedAt,
    this.pivot,
    required this.typealert,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        id: json["id"],
        typeAlertId: json["type_alert_id"],
        libelle: json["libelle"],
        fileUrl: json["file_url"],
        description: json["description"],
        statut: json["statut"],
        permanent: json["permanent"],
        randomVideo: json["randomvideo"],
        fin: json["fin"] == null ? null : DateTime.parse(json["fin"]),
        debut: json["debut"] == null ? null : DateTime.parse(json["debut"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot:
            json["pivot"] == null ? null : AlertPivot.fromJson(json["pivot"]),
        typealert: Typealert.fromJson(json["typealert"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_alert_id": typeAlertId,
        "libelle": libelle,
        "file_url": fileUrl,
        "description": description,
        "statut": statut,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
        "typealert": typealert.toJson(),
      };

  @override
  String toString() {
    return 'Alert(id: $id, typeAlertId: $typeAlertId, libelle: $libelle, fileUrl: $fileUrl, description: $description, statut: $statut, createdAt: $createdAt, updatedAt: $updatedAt, typealert : $typealert)';
  }

  Duration alertDuration() {
    return Duration(seconds: randomVideo);
  }
}

class AlertPivot {
  int? borneId;
  int? alertId;

  AlertPivot({
    this.borneId,
    this.alertId,
  });

  factory AlertPivot.fromJson(Map<String, dynamic> json) => AlertPivot(
        borneId: json["borne_id"],
        alertId: json["alert_id"],
      );

  Map<String, dynamic> toJson() => {
        "borne_id": borneId,
        "alert_id": alertId,
      };
}

class Typealert {
  int? id;
  String libelle;
  String? description;
  DateTime? createdAt;
  String? updatedAt;

  Typealert({
    this.id,
    required this.libelle,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Typealert.fromJson(Map<String, dynamic> json) => Typealert(
        id: json["id"],
        libelle: json["libelle"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
      };

  @override
  String toString() {
    return 'Typealert(id: $id, libelle: $libelle, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
