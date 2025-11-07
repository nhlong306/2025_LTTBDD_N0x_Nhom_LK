// File: lib/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  void _searchAndNavigate(BuildContext context, String city) async {
    if (city.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên thành phố.')),
      );
      return;
    }

    final provider = Provider.of<WeatherProvider>(context, listen: false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đang tìm kiếm thời tiết cho $city...')),
    );

    await provider.loadWeatherForCity(city);

    // Xử lý sau khi tải xong
    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${provider.errorMessage}')),
      );
    } else {
      // Nếu không có lỗi, quay lại màn hình chính một cách an toàn
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String cityName = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm Khu vực'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nhập tên thành phố (VD: London, Tokyo)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              onChanged: (value) {
                cityName = value;
              },
              onSubmitted: (_) => _searchAndNavigate(context, cityName),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Xem Thời Tiết'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _searchAndNavigate(context, cityName),
            ),
          ],
        ),
      ),
    );
  }
}
