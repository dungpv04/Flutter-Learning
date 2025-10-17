BÀI TẬP THỰC HÀNH FLUTTER
(BTTH SỐ 04 – LÀM VIỆC VỚI PHẦN CỨNG TRÊN THIẾT BỊ DI ĐỘNG)
Bài 1: Xây dựng Ứng dụng "Bản đồ nhiệt Sân trường"
Bối cảnh: Sân trường của chúng ta không chỉ có cây cối và sân bóng. Nó ẩn chứa nhiều đặc
điểm môi trường vô hình: có những nơi sáng hơn, những nơi có từ trường bất thường, và những
khu vực có mức độ "năng động" khác nhau. Nhiệm vụ của bạn là trở thành một nhà khoa học
dữ liệu di động, sử dụng Flutter để xây dựng một công cụ có khả năng khảo sát và lập bản đồ
các đặc điểm này.
Mục tiêu cuối cùng: Tạo ra một ứng dụng có thể thu thập và trực quan hóa dữ liệu môi trường
tại nhiều địa điểm khác nhau trong sân trường.
Yêu cầu Chức năng của Ứng dụng:
1. Màn hình "Trạm Khảo sát" (Survey Station): Đây là màn hình chính để thu thập dữ liệu.
• Hiển thị Dữ liệu Trực tiếp:
o Cường độ Ánh sáng: Hiển thị giá trị lux hiện tại từ Cảm biến Ánh sáng.
o Độ "Năng động": Tính toán và hiển thị độ lớn vector gia tốc (magnitude = sqrt(x²
+ y² + z²)) từ Gia tốc kế. Giá trị này đại diện cho mức độ rung động hoặc chuyển
động tại một địa điểm.
o Cường độ Từ trường: Hiển thị độ lớn vector từ trường từ Từ kế.
• Nút "Ghi Dữ liệu tại Điểm này":
o Khi nhấn nút, ứng dụng sẽ ngay lập tức:
1. Lấy tọa độ GPS (kinh độ, vĩ độ) chính xác.
2. Lấy tất cả các giá trị cảm biến hiện tại (ánh sáng, gia tốc, từ trường).
3. Gói tất cả dữ liệu này cùng với một dấu thời gian (DateTime.now()) vào một
bản ghi.
4. Lưu bản ghi này vào một file local (ví dụ: schoolyard_map_data.json).
2. Màn hình "Bản đồ Dữ liệu" (Data Map):
• Danh sách Điểm Khảo sát:
o Đọc toàn bộ dữ liệu từ file schoolyard_map_data.json.
o Hiển thị dữ liệu dưới dạng một danh sách (ListView). Mỗi item trong danh sách là
một Card đại diện cho một điểm đã khảo sát.
• Trực quan hóa Dữ liệu trên Card:
o Mỗi Card phải hiển thị rõ ràng tọa độ GPS đã ghi.
o Sử dụng các biểu tượng (icon) và màu sắc để biểu thị các giá trị cảm biến một
cách trực quan. Ví dụ:
▪ Ánh sáng: Dùng icon mặt trời . Giá trị lux càng cao, màu của icon càng
vàng đậm.
▪ Năng động: Dùng icon bước chân . Giá trị gia tốc càng lớn, màu của
icon càng đỏ.
▪ Từ trường: Dùng icon nam châm . Giá trị càng cao, màu của icon càng
xanh dương.
Nhiệm vụ của Sinh viên:
Giai đoạn 1: Lập trình (Tại phòng máy)
1. Thiết lập dự án: Tạo dự án Flutter, thêm các thư viện cần thiết (sensors_plus, location,
path_provider, permission_handler).
2. Cấu hình quyền: Đảm bảo đã xin đủ các quyền cho Vị trí (Location) và các quyền cần
thiết khác.
3. Xây dựng giao diện: Tạo 2 màn hình theo yêu cầu chức năng.
4. Tích hợp cảm biến: Viết code để đọc dữ liệu từ Gia tốc kế, Từ kế, và Cảm biến Ánh sáng.
Viết hàm để tính độ lớn vector.
5. Tích hợp GPS: Viết code để lấy vị trí hiện tại khi nhấn nút.
6. Xử lý File: Viết logic để lưu và đọc dữ liệu dưới dạng JSON.
Giai đoạn 2: Thu thập Dữ liệu (Tại sân trường)
1. Mở ứng dụng và di chuyển ra sân trường.
2. Nhiệm vụ: Tìm và ghi lại ít nhất 15 điểm dữ liệu tại các địa điểm có đặc điểm khác
nhau.
3. Gợi ý các địa điểm cần khảo sát:
o Điểm sáng nhất: Giữa sân trường vào lúc trời nắng.
o Điểm tối nhất: Dưới một tán cây rậm rạp hoặc một góc khuất.
o Điểm "tĩnh" nhất: Một góc yên tĩnh, không có ai qua lại (đặt điện thoại xuống đất
và chờ giá trị "Năng động" ổn định ở mức thấp).
o Điểm "năng động" nhất: Gần sân bóng rổ, khu vực có nhiều người qua lại (cầm
điện thoại trên tay và đi bộ).
o Điểm có từ trường bất thường: Hãy thử đến gần các vật thể kim loại lớn như cột
cờ, cột gôn, hàng rào sắt, hoặc nắp cống kim loại. Quan sát sự thay đổi của giá
trị Từ kế.
4. Quan sát: Khuyến khích sinh viên quan sát sự thay đổi của dữ liệu cảm biến trực tiếp
trên màn hình khi họ di chuyển.
Giai đoạn 3: Phân tích và Báo cáo (Tại phòng máy)
1. Mở lại ứng dụng và vào màn hình "Bản đồ Dữ liệu".
2. Phân tích: Dựa trên danh sách dữ liệu đã thu thập, trả lời các câu hỏi sau:
o Khu vực nào trong trường có cường độ ánh sáng cao nhất và thấp nhất? Tại sao?
o Dữ liệu về độ "Năng động" có phản ánh đúng thực tế khu vực bạn đã khảo sát
không?
o Bạn có tìm thấy điểm nào có từ trường cao bất thường không? Nó nằm ở gần vật
thể gì? . Báo cáo: Chụp ảnh màn hình "Bản đồ Dữ liệu" và viết một đoạn báo cáo
ngắn mô tả những phát hiện thú vị của bạn.
Bài 2: Xây dựng Game thăng bằng "Lăn bi"
Bối cảnh: Hầu hết các game trên điện thoại đều sử dụng các nút bấm ảo trên màn hình. Tuy
nhiên, một trong những cách tương tác độc đáo nhất mà smartphone mang lại là sử dụng chính
chuyển động vật lý của thiết bị. Bài tập này sẽ khai thác khả năng đó.
Mục tiêu: Xây dựng một mini-game đơn giản, trong đó người chơi phải nghiêng điện thoại để
điều khiển một quả bi lăn trên màn hình và đưa nó về "đích".
Yêu cầu Chức năng:
1. Giao diện Game:
• Sử dụng widget Stack để tạo một không gian 2D.
• Hiển thị một "Quả bi" (có thể là một Container hình tròn màu xanh).
• Hiển thị một "Đích" (có thể là một Container hình tròn, có viền, màu xám).
2. Logic Điều khiển:
• Sử dụng Gia tốc kế (Accelerometer) để điều khiển chuyển động của Quả bi.
o Khi người dùng nghiêng điện thoại sang trái/phải, giá trị event.x từ cảm biến sẽ
thay đổi vị trí ngang của Quả bi.
o Khi người dùng nghiêng điện thoại về phía trước/sau, giá trị event.y sẽ thay đổi vị
trí dọc của Quả bi.
• Cần có một cơ chế "làm mượt" hoặc giới hạn tốc độ để quả bi không di chuyển quá
nhanh và khó kiểm soát.
3. Logic Thắng cuộc:
• Ứng dụng phải liên tục kiểm tra xem vị trí của Quả bi có nằm trong khu vực của Đích hay
không.
• Khi Quả bi chạm vào Đích:
o Hiển thị một thông báo chiến thắng (ví dụ: một SnackBar hoặc một hộp thoại
AlertDialog).
o Nâng cao: Sau khi thắng, di chuyển Đích đến một vị trí ngẫu nhiên mới trên màn
hình để người chơi có thể tiếp tục chơi.
Hướng dẫn Thực hiện Từng bước:
Bước 1: Thiết lập và Giao diện Ban đầu
1. Tạo một dự án Flutter mới.
2. Thêm thư viện sensors_plus vào pubspec.yaml và chạy flutter pub get.
3. Tạo một StatefulWidget mới cho màn hình game, ví dụ: BalanceGameScreen.
4. Trong hàm build, sử dụng Stack để chứa Quả bi và Đích. Dùng widget Positioned để đặt
chúng lên màn hình.
Dart
// Biến để lưu vị trí ban đầu của quả bi
double ballX = 0, ballY = 0;
@override
Widget build(BuildContext context) {
 return Scaffold(
 body: Stack(
 children: [
 // Đích (cố định)
 Positioned(
 left: 150,
 top: 300,
 child: Container(
 width: 50,
 height: 50,
 decoration: BoxDecoration(
 shape: BoxShape.circle,
 border: Border.all(color: Colors.grey, width: 4),
 ),
 ),
 ),
 // Quả bi (sẽ di chuyển)
 Positioned(
 left: ballX,
 top: ballY,
 child: Container(
 width: 50,
 height: 50,
 decoration: const BoxDecoration(
 shape: BoxShape.circle,
 color: Colors.blue,
 ),
 ),
 ),
 ],
 ),
 );
}
Bước 2: Tích hợp Gia tốc kế và Điều khiển Quả bi
1. Trong initState, bắt đầu lắng nghe accelerometerEvents.
2. Bên trong hàm listen, sử dụng setState để cập nhật tọa độ ballX và ballY.
Dart
// Trong initState()
accelerometerEvents.listen((AccelerometerEvent event) {
 setState(() {
 // Cập nhật tọa độ X và Y của quả bi
 // event.x điều khiển chuyển động ngang, event.y điều khiển dọc
 // Dấu trừ (-) có thể cần thiết để đảo ngược hướng cho tự nhiên
 // Nhân với một hệ số (ví dụ: 5) để làm cho chuyển động rõ rệt hơn
 ballX += event.x * 5;
 ballY -= event.y * 5;
 // Thêm logic giới hạn để quả bi không đi ra ngoài màn hình
 // (Sử dụng MediaQuery.of(context).size.width/height)
 });
});
3. Quan trọng: Thêm logic để giới hạn ballX và ballY sao cho quả bi không thể lăn ra khỏi
các cạnh của màn hình.
Bước 3: Logic Kiểm tra Chiến thắng
1. Lưu tọa độ của Đích vào các biến (ví dụ: targetX, targetY).
2. Bên trong setState (ngay sau khi cập nhật vị trí quả bi), hãy viết một hàm
_checkWinCondition().
3. Hàm này sẽ tính khoảng cách giữa tâm của Quả bi và tâm của Đích.
o Gợi ý công thức khoảng cách: distance = sqrt(pow(ballCenterX - targetCenterX,
2) + pow(ballCenterY - targetCenterY, 2)).
4. Nếu khoảng cách này nhỏ hơn bán kính của Đích, nghĩa là Quả bi đã chạm vào Đích.
o Hiển thị thông báo chiến thắng.
o Nâng cao: Tạo ra giá trị targetX và targetY mới một cách ngẫu nhiên và gọi
setState để vẽ lại Đích ở vị trí mới.
Thử thách Nâng cao (Tùy chọn):
1. Vật cản: Thêm một vài Container hình chữ nhật màu đen vào Stack để làm "tường". Viết
logic phát hiện va chạm để Quả bi không thể đi xuyên qua các bức tường này.
2. Hệ thống tính giờ: Thêm một bộ đếm thời gian. Khi người chơi đưa được bi vào đích,
dừng bộ đếm và hiển thị thời gian hoàn thành. Có một nút "Chơi lại" để reset thời gian và
vị trí của bi/đích.
3. Điều khiển bằng Con quay hồi chuyển: Thay vì dùng accelerometerEvents, hãy thử
dùng gyroscopeEvents. Bạn sẽ phải cộng dồn các giá trị (x += event.x) vì con quay hồi
chuyển đo tốc độ góc. So sánh sự khác biệt trong cảm giác điều khiển.