import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherDetails {
  const WeatherDetails({
    required this.condition,
    required this.description,
    required this.temperatureCelsius,
    required this.humidity,
    required this.latitude,
    required this.longitude,
  });

  final String condition;
  final String description;
  final double temperatureCelsius;
  final int humidity;
  final double latitude;
  final double longitude;
}

class WeatherService {
 

   const WeatherService();

  String get apiKey => dotenv.env['OPEN_WEATHER_API_KEY']!;

  Future<WeatherDetails> getCurrentWeatherDetails() async {
    final position = await _getCurrentPosition();

    final uri = Uri.parse(
      'https://api.openweathermap.org/data/4.0/onecall/current'
      '?lat=${position.latitude}'
      '&lon=${position.longitude}'
      '&units=metric'
      '&lang=en'
      '&appid=$apiKey',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Weather API failed: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final dataList = json['data'] as List<dynamic>?;

    if (dataList == null || dataList.isEmpty) {
      throw Exception('Weather data is empty');
    }

    final current = dataList.first as Map<String, dynamic>;

    final weatherList = current['weather'] as List<dynamic>?;

    final weather = weatherList != null && weatherList.isNotEmpty
        ? weatherList.first as Map<String, dynamic>
        : <String, dynamic>{};

    return WeatherDetails(
      condition: weather['main']?.toString() ?? 'Unknown',
      description: weather['description']?.toString() ?? 'Unknown',
      temperatureCelsius: _toDouble(current['temp']),
      humidity: _toInt(current['humidity']),
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<Position> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location service is disabled');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}