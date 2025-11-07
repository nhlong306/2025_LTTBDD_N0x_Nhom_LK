// File: lib/weather_api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherApiClient {
  // Thay thế bằng API key của bạn!
  final String apiKey = '296f7d4e8d7142eb9aa80834250711';
  final String baseUrl = 'http://api.weatherapi.com/v1';

  // --- 1. Lấy thời tiết theo TỌA ĐỘ ---
  Future<Weather> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
        '$baseUrl/forecast.json?key=$apiKey&q=$latitude,$longitude&days=10&aqi=no&alerts=no');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Weather.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to load weather data by coordinates: ${response.statusCode}');
    }
  }

  // --- 2. Lấy thời tiết theo TÊN THÀNH PHỐ ---
  Future<Weather> fetchWeatherByCity(String city) async {
    final encodedCity = Uri.encodeComponent(city);
    final url = Uri.parse(
        '$baseUrl/forecast.json?key=$apiKey&q=$encodedCity&days=10&aqi=no&alerts=no');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Weather.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      throw Exception(
          'Không tìm thấy thành phố "$city". Vui lòng kiểm tra lại tên.');
    } else {
      throw Exception(
          'Failed to load weather data for $city: ${response.statusCode}');
    }
  }
}
