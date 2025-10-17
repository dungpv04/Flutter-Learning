class SurveyData {
  final double latitude;
  final double longitude;
  final double lightIntensity;
  final double dynamicLevel;
  final double magneticField;
  final DateTime timestamp;

  SurveyData({
    required this.latitude,
    required this.longitude,
    required this.lightIntensity,
    required this.dynamicLevel,
    required this.magneticField,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'lightIntensity': lightIntensity,
      'dynamicLevel': dynamicLevel,
      'magneticField': magneticField,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SurveyData.fromJson(Map<String, dynamic> json) {
    return SurveyData(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      lightIntensity: json['lightIntensity']?.toDouble() ?? 0.0,
      dynamicLevel: json['dynamicLevel']?.toDouble() ?? 0.0,
      magneticField: json['magneticField']?.toDouble() ?? 0.0,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
