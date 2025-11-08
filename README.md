ỨNG DỤNG THỜI TIẾT (WEATHER APP)

Đây là một dự án cuối kỳ môn Lập trình Thiết bị Di động, được phát triển bằng Flutter. Ứng dụng cung cấp thông tin thời tiết chi tiết, cập nhật theo thời gian thực và dự báo dài hạn (10 ngày) với giao diện hiện đại và trực quan.

1. Tính năng Nổi bật

Tính năng

Mô tả chi tiết

Dữ liệu Thời gian thực

Hiển thị nhiệt độ, điều kiện thời tiết, và các chỉ số chi tiết (Độ ẩm, UV Index, Áp suất, v.v.).

Dự báo 10 ngày

Cung cấp dự báo thời tiết chi tiết cho 10 ngày sắp tới.

Xác định vị trí

Tự động tải dữ liệu thời tiết dựa trên vị trí GPS hiện tại của người dùng.

Tìm kiếm linh hoạt

Cho phép người dùng tìm kiếm và xem thời tiết của bất kỳ thành phố nào trên thế giới.

Hiệu ứng động

Sử dụng Lottie Animations để hiển thị các biểu tượng thời tiết động (nắng, mưa, mây, bão) thay vì hình ảnh tĩnh.

Thông tin Nhóm

Có màn hình chuyên biệt để hiển thị thông tin về các thành viên phát triển.

2. Cấu trúc Công nghệ

Dự án được xây dựng trên kiến trúc Provider Pattern để quản lý trạng thái, đảm bảo tính dễ bảo trì và mở rộng.

Framework: Flutter (Dart)

Quản lý trạng thái: provider

API Dữ liệu: WeatherAPI.com

Vị trí: geolocator

Hiệu ứng: lottie

Mô hình Dữ liệu Chính

weather_model.dart: Định nghĩa mô hình dữ liệu (\texttt{Weather}) để ánh xạ dữ liệu nhận được từ API.

weather_provider.dart: Chứa toàn bộ logic kinh doanh (gọi API, xử lý lỗi, cập nhật trạng thái).

3. Hướng dẫn Cài đặt & Chạy ứng dụng

Để chạy ứng dụng này, bạn cần cài đặt Flutter SDK và có một khóa API (API Key) từ WeatherAPI.com.

Bước 3.1: Thiết lập API Key

Đăng ký tài khoản tại WeatherAPI.com.

Lấy API Key của bạn.

Mở file lib/weather_api_client.dart và thay thế <YOUR_API_KEY> bằng khóa API của bạn:

// lib/weather_api_client.dart
const String apiKey = 'YOUR_API_KEY'; 


Bước 3.2: Cài đặt Dependencies

Mở Terminal tại thư mục gốc của dự án và chạy:

flutter pub get


Bước 3.3: Chạy Ứng dụng

flutter run
# Hoặc chạy trên Chrome:
flutter run -d chrome 


4. Thông tin Nhóm Phát triển

Ứng dụng được phát triển bởi Nhóm [i] cho Môn Lập trình Thiết bị Di động.

Tên Thành viên

Mã số Sinh viên (ID)

[Nguyễn Hoàng Long]

[210106040]

[Nguyễn Duy Khánh]

[21010660]

[Thành viên khác (nếu có)]

[ID SV]
