import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';
import 'weather_model.dart';
import 'package:intl/intl.dart';
import 'search_screen.dart';
import 'package:lottie/lottie.dart';
import 'group_info_screen.dart'; // <<< Import màn hình thông tin nhóm

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // HÀM: Trả về đường dẫn Lottie Animation
  String _getWeatherAnimation(String condition) {
    final lowerCondition = condition.toLowerCase();

    if (lowerCondition.contains('sun') || lowerCondition.contains('clear')) {
      return 'assets/lottie/sun.json';
    } else if (lowerCondition.contains('cloud') ||
        lowerCondition.contains('overcast')) {
      return 'assets/lottie/overcast.json';
    } else if (lowerCondition.contains('rain') ||
        lowerCondition.contains('drizzle')) {
      return 'assets/lottie/rain.json';
    } else if (lowerCondition.contains('snow') ||
        lowerCondition.contains('sleet')) {
      return 'assets/lottie/snow icon.json';
    } else if (lowerCondition.contains('fog') ||
        lowerCondition.contains('mist')) {
      return 'assets/lottie/Weather Day - mist.json';
    } else if (lowerCondition.contains('thunder') ||
        lowerCondition.contains('storm')) {
      return 'assets/lottie/Weather-thunder.json';
    }

    return 'assets/lottie/sun.json'; // Default
  }

  // HÀM: Trả về danh sách màu nền
  List<Color> _getBackgroundColors(String condition) {
    if (condition.toLowerCase().contains('sun') ||
        condition.toLowerCase().contains('clear')) {
      return [Colors.blue.shade300, Colors.lightBlue.shade50];
    } else if (condition.toLowerCase().contains('rain') ||
        condition.toLowerCase().contains('snow')) {
      return [Colors.grey.shade700, Colors.blueGrey.shade900];
    } else if (condition.toLowerCase().contains('cloud')) {
      return [Colors.blueGrey.shade400, Colors.grey.shade100];
    }
    return [Colors.blue.shade400, Colors.lightBlue.shade100];
  }

  // HÀM: Trả về Icon (Vẫn cần cho List dự báo 10 ngày)
  IconData _getWeatherIcon(String condition) {
    final lowerCondition = condition.toLowerCase();
    if (lowerCondition.contains('sun') || lowerCondition.contains('clear')) {
      return Icons.wb_sunny;
    } else if (lowerCondition.contains('rain')) {
      return Icons.umbrella;
    } else if (lowerCondition.contains('cloud')) {
      return Icons.cloud;
    }
    return Icons.thermostat;
  }

  @override
  Widget build(BuildContext context) {
    // Gọi tải dữ liệu chỉ một lần sau khi build xong lần đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WeatherProvider>(context, listen: false);
      if (provider.weatherData == null && !provider.isLoading) {
        provider.loadWeatherForCurrentLocation();
      }
    });

    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          final weather = provider.weatherData;
          final city = weather?.city ?? 'Đang tải...';
          final condition = weather?.condition ?? 'clear';

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getBackgroundColors(condition),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: RefreshIndicator(
              onRefresh: provider.loadWeatherForCurrentLocation,
              color: Colors.white,
              child: CustomScrollView(
                slivers: [
                  // APPBAR: Luôn hiển thị (chứa nút Search, GPS VÀ Group Info)
                  _buildCustomAppBar(context, provider, city),

                  // NỘI DUNG CHÍNH (Sử dụng if/else if/else trong list children)
                  if (provider.isLoading && weather == null)
                    const SliverFillRemaining(
                      child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.white)),
                    )
                  else if (provider.errorMessage != null)
                    SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'Lỗi: ${provider.errorMessage}\n\nVui lòng sử dụng nút Tìm kiếm (🔍) hoặc GPS (⛟) để thử lại.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  else if (weather != null) ...[
                    // HIỂN THỊ DỮ LIỆU BÌNH THƯỜNG
                    _buildCurrentWeatherDetails(weather),

                    // TIÊU ĐỀ CHI TIẾT
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Thông tin chi tiết',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),

                    // LƯỚI CHI TIẾT - ĐÃ SỬA LỖI CÚ PHÁP SLIVERPADDING
                    _buildDetailGrid(weather),

                    // TIÊU ĐỀ DỰ BÁO
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'Dự báo 10 ngày tới',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),

                    // DANH SÁCH DỰ BÁO - ĐÃ SỬA LỖI CÚ PHÁP SLIVERPADDING
                    _buildForecastList(weather),

                    // KHOẢNG TRỐNG AN TOÀN
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 30),
                    ),
                  ] else
                    const SliverFillRemaining(
                      child: Center(
                          child: Text(
                        'Đang tải vị trí hoặc chưa có dữ liệu.',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 1. Custom AppBar (SliverAppBar) - CHỨA NÚT THÔNG TIN NHÓM
  Widget _buildCustomAppBar(
      BuildContext context, WeatherProvider provider, String city) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: TextButton.icon(
        icon: const Icon(Icons.location_on, color: Colors.white, size: 20),
        label: Text(
          city,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đang xem thời tiết tại $city')),
          );
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white70,
        ),
      ),
      centerTitle: true,
      actions: [
        // Nút Tìm kiếm
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
        ),
        // Nút GPS
        IconButton(
          icon: const Icon(Icons.gps_fixed, color: Colors.white),
          onPressed: () {
            provider.loadWeatherForCurrentLocation();
          },
        ),
        // NÚT THÔNG TIN NHÓM <<< Đây là nút bạn cần nhấn
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GroupInfoScreen()),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // 2. Phần Điều kiện Hiện tại - ĐÃ TÍCH HỢP LOTTIE
  SliverList _buildCurrentWeatherDetails(Weather weather) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  _getWeatherAnimation(weather.condition),
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                Text(
                  '${weather.tempC.round()}°C',
                  style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w100,
                      color: Colors.white),
                ),
                Text(
                  weather.condition,
                  style: const TextStyle(fontSize: 24, color: Colors.white70),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Chi tiết (Grid) - HÀM TRẢ VỀ SLIVERPADDING ĐỂ CÓ THỂ DÙNG TRỰC TIẾP
  Widget _buildDetailGrid(Weather weather) {
    final details = {
      'Độ ẩm': '${weather.humidity}%',
      'Điểm Sương': '${weather.dewpointC.round()}°C',
      'UV Index': weather.uvIndex.toString(),
      'Tầm Nhìn': '${weather.visibilityKm} km',
      'Khả năng Mưa': '${weather.chanceOfRain.round()}%',
      'Gió Động': '${weather.windSpeedKph.round()} kph',
      'Áp Suất': '${weather.pressureMb.round()} mb',
      'Bình Minh/Hoàng Hôn': '${weather.sunrise} / ${weather.sunset}',
    };

    // TRẢ VỀ SLIVERPADDING
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // Đã đổi 'slivers' thành 'sliver' để khắc phục lỗi
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: details.length,
        itemBuilder: (context, index) {
          final key = details.keys.elementAt(index);
          final value = details.values.elementAt(index);

          return ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(key,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w400)),
                    const SizedBox(height: 4),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 4. Dự báo 10 ngày - HÀM TRẢ VỀ SLIVERPADDING ĐỂ CÓ THỂ DÙNG TRỰC TIẾP
  Widget _buildForecastList(Weather weather) {
    // TRẢ VỀ SLIVERPADDING
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 20.0),
      sliver: SliverList.builder(
        itemCount: weather.forecast.length,
        itemBuilder: (context, index) {
          final forecast = weather.forecast[index];
          final dayName = DateFormat('EEE, d/M').format(forecast.date);

          String label;
          if (index == 0) {
            label = 'Hôm nay';
          } else if (index == 1) {
            label = 'Ngày mai';
          } else {
            label = dayName;
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(_getWeatherIcon(forecast.condition),
                    color: Colors.white),
                title: Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white)),
                subtitle: Text(forecast.condition,
                    style: TextStyle(color: Colors.white.withOpacity(0.8))),
                trailing: Text(
                  '${forecast.maxTempC.round()}° / ${forecast.minTempC.round()}°',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
