class Partenaire {
    int? id;
    String? name;
    String? adresse;
    String? logo;
    int? status;
    String? createdBy;
    DateTime? createdAt;
    DateTime? updatedAt;

    Partenaire({
        this.id,
        this.name,
        this.adresse,
        this.logo,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
    });

    factory Partenaire.fromJson(Map<String, dynamic> json) => Partenaire(
        id: json["id"],
        name: json["name"],
        adresse: json["adresse"],
        logo: json["logo"],
        status: json["status"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "adresse": adresse,
        "logo": logo,
        "status": status,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
