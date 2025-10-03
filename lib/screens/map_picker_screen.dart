import 'package:flutter/material.dart';
import 'dart:math' as math;

class MapPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const MapPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  double _latitude = 21.0285; // Default to Hanoi
  double _longitude = 105.8542;
  bool _hasSelectedLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _latitude = widget.initialLatitude!;
      _longitude = widget.initialLongitude!;
      _hasSelectedLocation = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Vị Trí'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _hasSelectedLocation ? _saveLocation : null,
            child: Text(
              'Lưu',
              style: TextStyle(
                color: _hasSelectedLocation ? Colors.white : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.withOpacity(0.1),
            child: Column(
              children: [
                const Text(
                  'Nhấn vào bản đồ để chọn vị trí',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_hasSelectedLocation) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Vị trí: ${_latitude.toStringAsFixed(6)}, ${_longitude.toStringAsFixed(6)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Map area (simulated)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.withOpacity(0.3),
                    Colors.blue.withOpacity(0.3),
                    Colors.brown.withOpacity(0.2),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Simulated map background
                  CustomPaint(
                    size: Size.infinite,
                    painter: MapPainter(),
                  ),
                  
                  // Tap detector
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _onMapTapped(details);
                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                  
                  // Pin marker
                  if (_hasSelectedLocation)
                    Positioned(
                      left: _getScreenX() - 12,
                      top: _getScreenY() - 24,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                  
                  // Instructions overlay
                  if (!_hasSelectedLocation)
                    const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.touch_app,
                                size: 48,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Nhấn vào bất kỳ đâu\ntrên bản đồ để chọn vị trí',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Bottom controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _hasSelectedLocation = false;
                      });
                    },
                    child: const Text('Xóa Vị Trí'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hasSelectedLocation ? _saveLocation : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Xác Nhận'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    
    // Convert screen coordinates to lat/lng (simplified simulation)
    final x = details.localPosition.dx / size.width;
    final y = details.localPosition.dy / size.height;
    
    // Simple conversion (not geographically accurate, just for demo)
    final newLat = 21.0285 + (y - 0.5) * 0.1; // Hanoi area
    final newLng = 105.8542 + (x - 0.5) * 0.1;
    
    setState(() {
      _latitude = newLat;
      _longitude = newLng;
      _hasSelectedLocation = true;
    });
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vị trí đã chọn: ${_latitude.toStringAsFixed(6)}, ${_longitude.toStringAsFixed(6)}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double _getScreenX() {
    // Convert longitude to screen X coordinate
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * ((_longitude - 105.8042) / 0.1 + 0.5);
  }

  double _getScreenY() {
    // Convert latitude to screen Y coordinate
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final infoHeight = 80.0; // Approximate height of info panel
    final bottomHeight = 80.0; // Approximate height of bottom controls
    final availableHeight = MediaQuery.of(context).size.height - 
        appBarHeight - statusBarHeight - infoHeight - bottomHeight;
    
    return infoHeight + availableHeight * ((21.0785 - _latitude) / 0.1 + 0.5);
  }

  void _saveLocation() {
    Navigator.pop(context, {
      'latitude': _latitude,
      'longitude': _longitude,
    });
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw grid lines to simulate map
    paint.color = Colors.grey.withOpacity(0.3);
    
    // Vertical lines
    for (int i = 0; i <= 10; i++) {
      final x = size.width * i / 10;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Horizontal lines
    for (int i = 0; i <= 10; i++) {
      final y = size.height * i / 10;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Draw some random "roads"
    paint.color = Colors.grey.withOpacity(0.5);
    paint.strokeWidth = 2.0;
    
    final random = math.Random(42); // Fixed seed for consistent pattern
    for (int i = 0; i < 15; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final endX = startX + (random.nextDouble() - 0.5) * 200;
      final endY = startY + (random.nextDouble() - 0.5) * 200;
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX.clamp(0, size.width), endY.clamp(0, size.height)),
        paint,
      );
    }
    
    // Draw some "buildings"
    paint.style = PaintingStyle.fill;
    paint.color = Colors.grey.withOpacity(0.2);
    
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final width = 10 + random.nextDouble() * 30;
      final height = 10 + random.nextDouble() * 30;
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
