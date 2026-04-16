import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ambience_model.dart';

class AmbienceRepository {
  Future<List<AmbienceModel>> loadAmbiences() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/ambiences.json');

    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData
        .map((item) => AmbienceModel.fromJson(item))
        .toList();
  }
}