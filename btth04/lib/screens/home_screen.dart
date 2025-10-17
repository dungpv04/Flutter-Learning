import 'package:flutter/material.dart';
import 'survey_station_screen.dart';
import 'balance_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BTTH04 - Flutter Hardware'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BÀI TẬP THỰC HÀNH FLUTTER',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'BTTH SỐ 04 – LÀM VIỆC VỚI PHẦN CỨNG TRÊN THIẾT BỊ DI ĐỘNG',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(
                  Icons.explore,
                  size: 40,
                  color: Colors.green,
                ),
                title: const Text(
                  'Bài 1: Bản đồ nhiệt Sân trường',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Thu thập và trực quan hóa dữ liệu môi trường',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SurveyStationScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(
                  Icons.sports_esports,
                  size: 40,
                  color: Colors.blue,
                ),
                title: const Text(
                  'Bài 2: Game thăng bằng "Lăn bi"',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Điều khiển quả bi bằng cảm biến gia tốc',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BalanceGameScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
