// ignore_for_file: public_member_api_docs, sort_constructors_first

class Article {
  int id;
  String title;
  String image;
  String url;
  String source;
  DateTime? datePub;
  String? nomSponsor;
  String? logoSponsor;
  int? statut;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  ArticlePivot pivot;

  Article({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.source,
    this.nomSponsor,
    this.logoSponsor,
    this.datePub,
    this.statut,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    required this.pivot,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        url: json["url"],
        source: json["source"],
        nomSponsor: json["nom_sponsor"],
        logoSponsor: json["logo_sponsor"],
        datePub:
            json["date_pub"] == null ? null : DateTime.parse(json["date_pub"]),
        statut: json["statut"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot: ArticlePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "url": url,
        "source": source,
        "date_pub":
            "${datePub!.year.toString().padLeft(4, '0')}-${datePub!.month.toString().padLeft(2, '0')}-${datePub!.day.toString().padLeft(2, '0')}",
        "statut": statut,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot.toJson(),
      };

  Duration seconde() {
    return Duration(seconds: pivot.duree);
  }

  @override
  String toString() {
    return 'Article(id: $id, title: $title, image: $image, url: $url, source: $source, nomSponsore: $nomSponsor, logoSPonsore: $logoSponsor, datePub: $datePub, statut: $statut, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  bool isEmpty() {
    // ignore: unnecessary_null_comparison
    return this == null ? true : false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => (id.hashCode ^ title.hashCode);
}

class ArticlePivot {
  int? borneId;
  int? articleId;
  int permanent;
  int duree;
  DateTime debut;
  DateTime fin;

  ArticlePivot({
    this.borneId,
    this.articleId,
    required this.permanent,
    required this.duree,
    required this.debut,
    required this.fin,
  });

  factory ArticlePivot.fromJson(Map<String, dynamic> json) => ArticlePivot(
        borneId: json["borne_id"],
        articleId: json["article_id"],
        permanent: json["permanent"],
        duree: json["duree"],
        debut: DateTime.parse(json["debut"]),
        fin: DateTime.parse(json["fin"]),
      );

  Map<String, dynamic> toJson() => {
        "borne_id": borneId,
        "article_id": articleId,
        "permanent": permanent,
        "duree": duree,
        "debut":
            "${debut.year.toString().padLeft(4, '0')}-${debut.month.toString().padLeft(2, '0')}-${debut.day.toString().padLeft(2, '0')}",
        "fin":
            "${fin.year.toString().padLeft(4, '0')}-${fin.month.toString().padLeft(2, '0')}-${fin.day.toString().padLeft(2, '0')}",
      };

  @override
  String toString() {
    return 'ArticlePivot(borneId: $borneId, articleId: $articleId, permanent : $permanent, duree: $duree, debut: $debut, fin: $fin)';
  }
}
