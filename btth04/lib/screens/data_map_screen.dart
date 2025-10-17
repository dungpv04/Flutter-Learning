import 'package:flutter/material.dart';
import '../models/survey_data.dart';
import '../utils/data_storage.dart';

class DataMapScreen extends StatefulWidget {
  const DataMapScreen({super.key});

  @override
  State<DataMapScreen> createState() => _DataMapScreenState();
}

class _DataMapScreenState extends State<DataMapScreen> {
  List<SurveyData> _surveyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DataStorage.loadSurveyData();
    setState(() {
      _surveyData = data;
      _isLoading = false;
    });
  }

  Color _getLightIntensityColor(double intensity) {
    // Map intensity (0-1000) to yellow color intensity
    final normalizedIntensity = (intensity / 1000).clamp(0.0, 1.0);
    return Color.lerp(Colors.yellow.shade100, Colors.yellow.shade800, normalizedIntensity) ?? Colors.yellow;
  }

  Color _getDynamicLevelColor(double level) {
    // Map dynamic level (0-20) to red color intensity
    final normalizedLevel = (level / 20).clamp(0.0, 1.0);
    return Color.lerp(Colors.red.shade100, Colors.red.shade800, normalizedLevel) ?? Colors.red;
  }

  Color _getMagneticFieldColor(double field) {
    // Map magnetic field (0-100) to blue color intensity
    final normalizedField = (field / 100).clamp(0.0, 1.0);
    return Color.lerp(Colors.blue.shade100, Colors.blue.shade800, normalizedField) ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ Dữ liệu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _surveyData.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Chưa có dữ liệu khảo sát',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hãy quay lại Trạm Khảo sát để ghi dữ liệu',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _surveyData.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final data = _surveyData[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // GPS Coordinates
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'GPS: ${data.latitude.toStringAsFixed(6)}, ${data.longitude.toStringAsFixed(6)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Timestamp
                            Text(
                              'Thời gian: ${_formatDateTime(data.timestamp)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Sensor Data Icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Light Intensity
                                _buildSensorIcon(
                                  icon: Icons.wb_sunny,
                                  value: '${data.lightIntensity.toStringAsFixed(0)} lux',
                                  color: _getLightIntensityColor(data.lightIntensity),
                                  label: 'Ánh sáng',
                                ),
                                
                                // Dynamic Level
                                _buildSensorIcon(
                                  icon: Icons.directions_run,
                                  value: '${data.dynamicLevel.toStringAsFixed(1)} m/s²',
                                  color: _getDynamicLevelColor(data.dynamicLevel),
                                  label: 'Năng động',
                                ),
                                
                                // Magnetic Field
                                _buildSensorIcon(
                                  icon: Icons.explore,
                                  value: '${data.magneticField.toStringAsFixed(1)} μT',
                                  color: _getMagneticFieldColor(data.magneticField),
                                  label: 'Từ trường',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: _surveyData.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showSummaryDialog,
              icon: const Icon(Icons.analytics),
              label: const Text('Phân tích'),
            )
          : null,
    );
  }

  Widget _buildSensorIcon({
    required IconData icon,
    required String value,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showSummaryDialog() {
    if (_surveyData.isEmpty) return;

    // Calculate statistics
    final lightValues = _surveyData.map((e) => e.lightIntensity).toList();
    final dynamicValues = _surveyData.map((e) => e.dynamicLevel).toList();
    final magneticValues = _surveyData.map((e) => e.magneticField).toList();

    lightValues.sort();
    dynamicValues.sort();
    magneticValues.sort();

    final maxLight = lightValues.last;
    final minLight = lightValues.first;
    final maxDynamic = dynamicValues.last;
    final minDynamic = dynamicValues.first;
    final maxMagnetic = magneticValues.last;
    final minMagnetic = magneticValues.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phân tích Dữ liệu'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tổng số điểm khảo sát: ${_surveyData.length}'),
              const SizedBox(height: 16),
              
              const Text(
                'Cường độ Ánh sáng:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Cao nhất: ${maxLight.toStringAsFixed(1)} lux'),
              Text('• Thấp nhất: ${minLight.toStringAsFixed(1)} lux'),
              const SizedBox(height: 12),
              
              const Text(
                'Độ Năng động:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Cao nhất: ${maxDynamic.toStringAsFixed(2)} m/s²'),
              Text('• Thấp nhất: ${minDynamic.toStringAsFixed(2)} m/s²'),
              const SizedBox(height: 12),
              
              const Text(
                'Cường độ Từ trường:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Cao nhất: ${maxMagnetic.toStringAsFixed(2)} μT'),
              Text('• Thấp nhất: ${minMagnetic.toStringAsFixed(2)} μT'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
