import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/survey_data.dart';

class DataStorage {
  static const String fileName = 'schoolyard_map_data.json';

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<void> saveSurveyData(SurveyData data) async {
    try {
      final file = await _localFile;
      List<SurveyData> existingData = await loadSurveyData();
      existingData.add(data);
      
      final jsonData = existingData.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  static Future<List<SurveyData>> loadSurveyData() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((e) => SurveyData.fromJson(e)).toList();
    } catch (e) {
      print('Error loading data: $e');
      return [];
    }
  }
}
