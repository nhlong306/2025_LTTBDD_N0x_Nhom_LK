import 'package:flutter/material.dart';
// Đã xóa: import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Đã xóa: final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // Dùng chuỗi cố định
          'Thông tin Nhóm',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Tiêu đề lớn của dự án
            const Text(
              // Dùng chuỗi cố định
              'ĐỒ ÁN LẬP TRÌNH THIẾT BỊ DI ĐỘNG',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 11, 80, 163),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 24),

            // Phần thông tin nhóm
            const Text(
              // Dùng chuỗi cố định
              'THÔNG TIN THÀNH VIÊN',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 34, 34, 34),
              ),
            ),
            const SizedBox(height: 16),

            // Danh sách thành viên (chỉ giữ lại Tên và MSSV)
            _buildMemberCard(
              context,
              name: 'Nguyễn Hoàng Long',
              id: '210106640',
            ),
            _buildMemberCard(
              context,
              name: 'Nguyễn Duy Khánh',
              id: '210106660',
            ),

            const SizedBox(height: 32),

            // Thông tin chi tiết dự án
            const Text(
              'THÔNG TIN DỰ ÁN',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 34, 34, 34),
              ),
            ),
            const SizedBox(height: 16),
            _buildProjectDetail('Tên ứng dụng:', 'Weather App Final'),
            _buildProjectDetail('Mục tiêu:',
                'Xây dựng ứng dụng thời tiết với Lottie Animation và Geolocation.'),
            _buildProjectDetail('Công nghệ:', 'Flutter (Dart)'),
            _buildProjectDetail('API:', 'WeatherAPI.com'),
            _buildProjectDetail('Mô tả:',
                'Ứng dụng này được phát triển bằng Flutter cho môn Lập trình Thiết bị Di động.'), // Dùng chuỗi cố định
          ],
        ),
      ),
    );
  }

  // Widget phụ trợ để hiển thị thông tin từng thành viên
  Widget _buildMemberCard(BuildContext context,
      {required String name, required String id}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 4),
            // Chỉ giữ lại MSSV
            Text('MSSV: $id',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Widget phụ trợ để hiển thị thông tin dự án
  Widget _buildProjectDetail(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
