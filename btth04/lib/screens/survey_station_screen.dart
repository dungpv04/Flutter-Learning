import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:location/location.dart';
import '../models/survey_data.dart';
import '../utils/data_storage.dart';
import '../utils/sensor_utils.dart';
import 'data_map_screen.dart';

class SurveyStationScreen extends StatefulWidget {
  const SurveyStationScreen({super.key});

  @override
  State<SurveyStationScreen> createState() => _SurveyStationScreenState();
}

class _SurveyStationScreenState extends State<SurveyStationScreen> {
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  late StreamSubscription<MagnetometerEvent> _magnetometerSubscription;
  
  double _lightIntensity = 0.0;
  double _dynamicLevel = 0.0;
  double _magneticField = 0.0;
  
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initializeSensors();
  }

  Future<void> _requestPermissions() async {
    // Request location permissions
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void _initializeSensors() {
    // Listen to accelerometer for dynamic level
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _dynamicLevel = SensorUtils.calculateMagnitude(event.x, event.y, event.z);
      });
    });

    // Listen to magnetometer for magnetic field
    _magnetometerSubscription = magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magneticField = SensorUtils.calculateMagnitude(event.x, event.y, event.z);
      });
    });

    // Simulate light sensor (as Flutter doesn't have direct light sensor access)
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          // Simulate light intensity between 0-1000 lux
          _lightIntensity = 200 + (DateTime.now().millisecondsSinceEpoch % 800);
        });
      }
    });
  }

  Future<void> _recordDataAtCurrentLocation() async {
    if (_isRecording) return;
    
    setState(() {
      _isRecording = true;
    });

    try {
      // Get current location
      _locationData = await location.getLocation();
      
      if (_locationData != null) {
        final surveyData = SurveyData(
          latitude: _locationData!.latitude ?? 0.0,
          longitude: _locationData!.longitude ?? 0.0,
          lightIntensity: _lightIntensity,
          dynamicLevel: _dynamicLevel,
          magneticField: _magneticField,
          timestamp: DateTime.now(),
        );

        await DataStorage.saveSurveyData(surveyData);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dữ liệu đã được ghi lại thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi ghi dữ liệu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isRecording = false;
      });
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    _magnetometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trạm Khảo sát'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataMapScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Dữ liệu Trực tiếp',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  _buildSensorCard(
                    icon: Icons.wb_sunny,
                    title: 'Cường độ Ánh sáng',
                    value: '${_lightIntensity.toStringAsFixed(1)} lux',
                    color: Colors.yellow.shade700,
                  ),
                  const SizedBox(height: 16),
                  _buildSensorCard(
                    icon: Icons.directions_run,
                    title: 'Độ "Năng động"',
                    value: '${_dynamicLevel.toStringAsFixed(2)} m/s²',
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  _buildSensorCard(
                    icon: Icons.explore,
                    title: 'Cường độ Từ trường',
                    value: '${_magneticField.toStringAsFixed(2)} μT',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 32),
                  if (_locationData != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Vị trí hiện tại:',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    'Lat: ${_locationData!.latitude?.toStringAsFixed(6) ?? "N/A"}',
                                  ),
                                  Text(
                                    'Lng: ${_locationData!.longitude?.toStringAsFixed(6) ?? "N/A"}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isRecording ? null : _recordDataAtCurrentLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: _isRecording
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Đang ghi...'),
                        ],
                      )
                    : const Text(
                        'Ghi Dữ liệu tại Điểm này',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
