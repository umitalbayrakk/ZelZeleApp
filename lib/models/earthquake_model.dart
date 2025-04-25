class EarthquakeModel {
  final double magnitude;
  final String place;
  final DateTime time;

  EarthquakeModel({required this.magnitude, required this.place, required this.time});

  factory EarthquakeModel.fromJson(Map<String, dynamic> json) {
    final timeData = json['properties']['time'];
    DateTime parsedTime;

    if (timeData is int) {
      parsedTime = DateTime.fromMillisecondsSinceEpoch(timeData);
    } else if (timeData is String) {
      parsedTime = DateTime.parse(timeData);
    } else {
      parsedTime = DateTime.now();
    }

    return EarthquakeModel(
      magnitude: (json['properties']['mag'] ?? 0.0).toDouble(),
      place: json['properties']['place'] ?? 'Unknown',
      time: parsedTime,
    );
  }
}
