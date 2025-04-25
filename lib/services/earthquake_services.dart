import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/earthquake_model.dart';

class EarthquakeService {
  final String _baseUrl = 'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson';

  Future<List<EarthquakeModel>> fetchEarthquakesForDay({required DateTime date}) async {
    final String formattedDate = date.toIso8601String().split('T')[0];
    final String startTime = formattedDate;
    final String endTime = formattedDate + 'T23:59:59';
    final String url = '$_baseUrl&starttime=$startTime&endtime=$endTime';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List features = data['features'];
      List<EarthquakeModel> allQuakes = features.map((e) => EarthquakeModel.fromJson(e)).toList();
      return allQuakes.where((quake) {
        final place = quake.place.toLowerCase();
        return place.contains('turkey') || place.contains('türkiye');
      }).toList();
    } else {
      throw Exception('Deprem verisi yüklenemedi');
    }
  }
  Future<List<EarthquakeModel>> fetchEarthquakes() async {
    final response = await http.get(
      Uri.parse('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List features = data['features'];
      List<EarthquakeModel> allQuakes = features.map((e) => EarthquakeModel.fromJson(e)).toList();
      return allQuakes.where((quake) {
        final place = quake.place.toLowerCase();
        return place.contains('turkey') || place.contains('türkiye');
      }).toList();
    } else {
      throw Exception('Deprem verisi yüklenemedi');
    }
  }
}
