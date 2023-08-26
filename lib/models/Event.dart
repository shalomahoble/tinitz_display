// ignore_for_file: public_member_api_docs, sort_constructors_first
class Event {
  int? id;
  String? libelle;
  String? description;
  String? image;
  int? prix;
  DateTime? dateDebut;
  DateTime? dateFin;
  String? organisateur;
  String? ville;
  String? adresse;
  String url;
  int? paysId;
  String? email;
  String? telephone;
  int? status;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Event({
    this.id,
    this.libelle,
    this.description,
    this.image,
    this.prix,
    this.dateDebut,
    this.dateFin,
    this.organisateur,
    this.ville,
    this.adresse,
    required this.url,
    this.paysId,
    this.email,
    this.telephone,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        libelle: json["libelle"],
        description: json["description"],
        image: json["image"],
        prix: json["prix"],
        dateDebut: json["date_debut"] == null
            ? null
            : DateTime.parse(json["date_debut"]),
        dateFin:
            json["date_fin"] == null ? null : DateTime.parse(json["date_fin"]),
        organisateur: json["organisateur"],
        ville: json["ville"],
        adresse: json["adresse"],
        url: json["url"],
        paysId: json["pays_id"],
        email: json["email"],
        telephone: json["telephone"],
        status: json["status"],
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
        "description": description,
        "image": image,
        "prix": prix,
        "date_debut": dateDebut?.toIso8601String(),
        "date_fin": dateFin?.toIso8601String(),
        "organisateur": organisateur,
        "ville": ville,
        "adresse": adresse,
        "url": url,
        "pays_id": paysId,
        "email": email,
        "telephone": telephone,
        "status": status,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'Event(id: $id, libelle: $libelle, description: $description, image: $image, prix: $prix, dateDebut: $dateDebut, dateFin: $dateFin, organisateur: $organisateur, ville: $ville, adresse: $adresse, url: $url, paysId: $paysId, email: $email, telephone: $telephone, status: $status, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
