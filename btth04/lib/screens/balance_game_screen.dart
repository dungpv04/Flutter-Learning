import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../utils/sensor_utils.dart';

class BalanceGameScreen extends StatefulWidget {
  const BalanceGameScreen({super.key});

  @override
  State<BalanceGameScreen> createState() => _BalanceGameScreenState();
}

class _BalanceGameScreenState extends State<BalanceGameScreen> {
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  
  // Ball position
  double ballX = 0;
  double ballY = 0;
  
  // Target position
  double targetX = 150;
  double targetY = 300;
  
  // Ball and target sizes
  static const double ballSize = 50;
  static const double targetSize = 50;
  
  // Screen dimensions
  double screenWidth = 0;
  double screenHeight = 0;
  
  // Game state
  bool isGameActive = false;
  int score = 0;
  DateTime? gameStartTime;
  Duration? bestTime;
  
  // Smoothing factor for ball movement
  static const double smoothingFactor = 3.0;

  @override
  void initState() {
    super.initState();
    _initializeAccelerometer();
  }

  void _initializeAccelerometer() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      if (!isGameActive) return;
      
      setState(() {
        // Update ball position based on accelerometer data
        // Multiply by smoothing factor to make movement more responsive
        // Use negative values to make tilting feel natural
        ballX += -event.x * smoothingFactor;
        ballY += event.y * smoothingFactor;
        
        // Keep ball within screen bounds
        ballX = ballX.clamp(0, screenWidth - ballSize);
        ballY = ballY.clamp(0, screenHeight - ballSize);
        
        // Check win condition
        _checkWinCondition();
      });
    });
  }

  void _checkWinCondition() {
    // Calculate distance between ball center and target center
    final ballCenterX = ballX + ballSize / 2;
    final ballCenterY = ballY + ballSize / 2;
    final targetCenterX = targetX + targetSize / 2;
    final targetCenterY = targetY + targetSize / 2;
    
    final distance = SensorUtils.calculateDistance(
      ballCenterX, ballCenterY, 
      targetCenterX, targetCenterY
    );
    
    // If ball is close enough to target (overlapping)
    if (distance < (ballSize + targetSize) / 4) {
      _onWin();
    }
  }

  void _onWin() {
    final completionTime = DateTime.now().difference(gameStartTime!);
    
    // Update best time
    if (bestTime == null || completionTime < bestTime!) {
      bestTime = completionTime;
    }
    
    setState(() {
      score++;
      isGameActive = false;
    });
    
    // Show win dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Chúc mừng!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bạn đã hoàn thành trong ${completionTime.inSeconds} giây!'),
            if (bestTime != null)
              Text('Thời gian tốt nhất: ${bestTime!.inSeconds} giây'),
            Text('Điểm số: $score'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startNewRound();
            },
            child: const Text('Chơi tiếp'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Chơi lại'),
          ),
        ],
      ),
    );
  }

  void _startNewRound() {
    final random = Random();
    setState(() {
      // Move target to random position
      targetX = random.nextDouble() * (screenWidth - targetSize);
      targetY = random.nextDouble() * (screenHeight - targetSize);
      
      // Reset ball to center
      ballX = screenWidth / 2 - ballSize / 2;
      ballY = screenHeight / 2 - ballSize / 2;
      
      isGameActive = true;
      gameStartTime = DateTime.now();
    });
  }

  void _resetGame() {
    setState(() {
      score = 0;
      bestTime = null;
      isGameActive = false;
      
      // Reset positions
      ballX = screenWidth / 2 - ballSize / 2;
      ballY = screenHeight / 2 - ballSize / 2;
      targetX = 150;
      targetY = 300;
    });
  }

  void _startGame() {
    setState(() {
      isGameActive = true;
      gameStartTime = DateTime.now();
      
      // Reset ball to center
      ballX = screenWidth / 2 - ballSize / 2;
      ballY = screenHeight / 2 - ballSize / 2;
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Lăn bi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (score > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Điểm: $score',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          screenWidth = constraints.maxWidth;
          screenHeight = constraints.maxHeight;
          
          // Initialize ball position to center if not set
          if (ballX == 0 && ballY == 0) {
            ballX = screenWidth / 2 - ballSize / 2;
            ballY = screenHeight / 2 - ballSize / 2;
          }
          
          return Stack(
            children: [
              // Game instructions
              if (!isGameActive)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.sports_esports,
                        size: 64,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Game Thăng bằng "Lăn bi"',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Nghiêng điện thoại để điều khiển quả bi xanh và đưa nó vào đích (viền xám).',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _startGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          score == 0 ? 'Bắt đầu' : 'Tiếp tục',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      if (score > 0) ...[
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _resetGame,
                          child: const Text('Chơi lại từ đầu'),
                        ),
                      ],
                      if (bestTime != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Thời gian tốt nhất: ${bestTime!.inSeconds} giây',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              
              // Target (destination)
              Positioned(
                left: targetX,
                top: targetY,
                child: Container(
                  width: targetSize,
                  height: targetSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 4),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.flag,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
              
              // Ball
              Positioned(
                left: ballX,
                top: ballY,
                child: Container(
                  width: ballSize,
                  height: ballSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Game timer
              if (isGameActive && gameStartTime != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: StreamBuilder(
                      stream: Stream.periodic(const Duration(milliseconds: 100)),
                      builder: (context, snapshot) {
                        final elapsed = DateTime.now().difference(gameStartTime!);
                        return Text(
                          '${elapsed.inSeconds}s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
