import 'dart:convert';

import 'package:borne_flutter/models/caisse.dart';
import 'package:intl/intl.dart';

class Ticket {
  final int id;
  final String numClient;
  final int? statut;
  final dynamic clotureId;
  final int? caisseId;
  final int? serviceId;
  final DateTime createdAt;
  final String? updatedAt;
  final Caisse caisse;

  Ticket({
    required this.id,
    required this.numClient,
    this.statut,
    this.clotureId,
    this.caisseId,
    this.serviceId,
    required this.createdAt,
    this.updatedAt,
    required this.caisse,
  });

  factory Ticket.fromRawJson(String str) => Ticket.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        numClient: json["num_client"],
        statut: json["statut"],
        clotureId: json["cloture_id"],
        caisseId: json["caisse_id"],
        serviceId: json["service_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        caisse: Caisse.fromJson(json["caisse"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "num_client": numClient,
        "statut": statut,
        "cloture_id": clotureId,
        "caisse_id": caisseId,
        "service_id": serviceId,
        "created_at":
            "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
        "updated_at": updatedAt,
        "caisse": caisse.toJson(),
      };

  @override
  String toString() {
    return 'Client(id: $id, numClient: $numClient, statut: $statut, clotureId: $clotureId, caisseId: $caisseId, serviceId: $serviceId, createdAt: $createdAt, updatedAt: $updatedAt, caisse: $caisse)';
  }

  String createdAtDate() {
    return "${DateFormat('EEE, MMM d ', 'fr_Fr').format(createdAt)}${DateFormat('HH:mm', 'fr_Fr').format(createdAt)}";
  }
}
