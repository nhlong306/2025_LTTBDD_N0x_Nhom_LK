// File: lib/weather_model.dart

class Weather {
  final String city;
  final double tempC;
  final String condition;
  final int humidity;
  final double windSpeedKph;
  final double pressureMb;
  final double uvIndex;
  // Lưu ý: Các trường dưới đây có thể nằm trong các phần JSON khác nhau tùy API.
  final double dewpointC;
  final double visibilityKm;
  final double chanceOfRain;
  final String sunrise;
  final String sunset;
  final List<ForecastDay> forecast;

  Weather({
    required this.city,
    required this.tempC,
    required this.condition,
    required this.humidity,
    required this.windSpeedKph,
    required this.pressureMb,
    required this.uvIndex,
    required this.dewpointC,
    required this.visibilityKm,
    required this.chanceOfRain,
    required this.sunrise,
    required this.sunset,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // Xử lý truy cập an toàn cho các nested fields
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final forecastData = json['forecast']?['forecastday'] as List? ?? [];

    // Lấy thông tin chi tiết cho ngày hôm nay (day 0)
    final todayForecast = forecastData.isNotEmpty ? forecastData[0] : null;
    final todayDetails = todayForecast?['day'] as Map<String, dynamic>? ?? {};
    final astroDetails = todayForecast?['astro'] as Map<String, dynamic>? ?? {};

    return Weather(
      city: location['name'] ?? 'Unknown',
      tempC: (current['temp_c'] as num?)?.toDouble() ?? 0.0,
      condition: current['condition']?['text'] ?? 'N/A',
      humidity: current['humidity'] ?? 0,
      windSpeedKph: (current['wind_kph'] as num?)?.toDouble() ?? 0.0,
      pressureMb: (current['pressure_mb'] as num?)?.toDouble() ?? 0.0,
      uvIndex: (current['uv'] as num?)?.toDouble() ?? 0.0,

      // Các trường chi tiết phải được truy cập an toàn
      // Lưu ý: dewpoint, vis_km thường không có sẵn trong mọi API/mọi điều kiện
      dewpointC: (current['dewpoint_c'] as num?)?.toDouble() ?? 0.0,
      visibilityKm: (current['vis_km'] as num?)?.toDouble() ?? 0.0,

      // Sử dụng trường 'chance_of_rain' phổ biến, mặc định là 0.0
      chanceOfRain:
          (todayDetails['daily_chance_of_rain'] as num?)?.toDouble() ?? 0.0,

      sunrise: astroDetails['sunrise'] ?? 'N/A',
      sunset: astroDetails['sunset'] ?? 'N/A',

      // Tạo danh sách dự báo
      forecast: forecastData
          .map((day) => ForecastDay.fromJson(day as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ForecastDay {
  final DateTime date;
  final double maxTempC;
  final double minTempC;
  final String condition;

  ForecastDay({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.condition,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    final dayData = json['day'] as Map<String, dynamic>? ?? {};

    return ForecastDay(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      maxTempC: (dayData['maxtemp_c'] as num?)?.toDouble() ?? 0.0,
      minTempC: (dayData['mintemp_c'] as num?)?.toDouble() ?? 0.0,
      condition: dayData['condition']?['text'] ?? 'N/A',
    );
  }
}
