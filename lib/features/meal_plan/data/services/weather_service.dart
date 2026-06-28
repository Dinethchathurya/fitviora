import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  const WeatherService({
    required this.apiKey,
  });

  final String apiKey;

  Future<String> getCurrentWeatherCondition() async {
    const latitude = 6.9271;
    const longitude = 79.8612;

    final uri = Uri.parse(
      // 'https://api.openweathermap.org/data/2.5/weather'
      'https://api.openweathermap.org/data/4.0/onecall/current'
      '?lat=$latitude'
      '&lon=$longitude'
      '&appid=$apiKey'
      '&units=metric',
    );

    final response = await http.get(uri);
    print('Weather API Response: ${response.body}');

    if (response.statusCode != 200) {
      return 'Unknown';
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final weatherList = json['weather'] as List?;

    if (weatherList == null || weatherList.isEmpty) {
      return 'Unknown';
    }

    final main = weatherList.first['main']?.toString() ?? 'Unknown';

    return main;
  }
}