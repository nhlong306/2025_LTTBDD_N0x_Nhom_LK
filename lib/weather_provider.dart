// File: lib/weather_provider.dart

import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'weather_api_client.dart';
import 'location_service.dart';
import 'package:geolocator/geolocator.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  Weather? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final WeatherApiClient _apiClient = WeatherApiClient();
  final LocationService _locationService = LocationService();

  Future<void> loadWeatherForCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Position? position = await _locationService.getCurrentLocation();
      if (position != null) {
        _weatherData = await _apiClient.fetchWeather(
            position.latitude, position.longitude);
      } else {
        _errorMessage = "Không thể xác định vị trí hiện tại.";
      }
    } catch (e) {
      _errorMessage = "Lỗi tải dữ liệu: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWeatherForCity(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weatherData = await _apiClient.fetchWeatherByCity(city);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
