import 'dart:convert';

import 'models.dart';

class CastResponse {
  CastResponse({
    required this.id,
    required this.cast,
  });

  int id;
  List<Cast> cast;

  factory CastResponse.fromJson(String str) =>
      CastResponse.fromMap(json.decode(str));

  factory CastResponse.fromMap(Map<String, dynamic> json) => CastResponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromMap(x))),
      );
}
