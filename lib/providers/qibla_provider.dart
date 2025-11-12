import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import '../services/qibla_service.dart';
import '../services/location_service.dart';

class QiblaProvider extends ChangeNotifier {
  final QiblaService _qiblaService = QiblaService();
  final LocationService _locationService = LocationService();

  Position? _currentPosition;
  QiblahDirection? _qiblahDirection;
  double? _manualQiblaDirection;
  double? _distanceToKaaba;
  bool _isLoading = false;
  String? _error;
  bool _isQiblaServiceSupported = false;

  // Getters
  Position? get currentPosition => _currentPosition;
  QiblahDirection? get qiblahDirection => _qiblahDirection;
  double? get manualQiblaDirection => _manualQiblaDirection;
  double? get distanceToKaaba => _distanceToKaaba;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isQiblaServiceSupported => _isQiblaServiceSupported;
  
  Stream<QiblahDirection>? get qiblahStream => _qiblaService.qiblahStream;

  QiblaProvider() {
    _initializeQibla();
  }

  Future<void> _initializeQibla() async {
    _setLoading(true);
    _error = null;

    try {
      // Initialize Qibla service
      _isQiblaServiceSupported = await _qiblaService.initialize();
      
      // Get current location
      _currentPosition = await _locationService.getCurrentLocation();
      
      if (_currentPosition != null) {
        // Calculate distance to Kaaba
        _distanceToKaaba = _qiblaService.calculateDistanceToKaaba(_currentPosition!);
        
        // If Qibla service is not supported, calculate manually
        if (!_isQiblaServiceSupported) {
          _manualQiblaDirection = await _qiblaService.calculateQiblaDirection(_currentPosition!);
        }
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error initializing Qibla: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshQibla() async {
    await _initializeQibla();
  }

  void updateQiblahDirection(QiblahDirection direction) {
    _qiblahDirection = direction;
    notifyListeners();
  }

  String getQiblaDirectionText() {
    if (_qiblahDirection != null) {
      return '${_qiblahDirection!.qiblah.toInt()}°';
    } else if (_manualQiblaDirection != null) {
      return '${_manualQiblaDirection!.toInt()}°';
    }
    return 'N/A';
  }

  String getCompassDirectionText() {
    double direction = 0;
    if (_qiblahDirection != null) {
      direction = _qiblahDirection!.qiblah;
    } else if (_manualQiblaDirection != null) {
      direction = _manualQiblaDirection!;
    }
    return _qiblaService.getDirectionName(direction);
  }

  String getDistanceText() {
    if (_distanceToKaaba != null) {
      return _qiblaService.formatDistance(_distanceToKaaba!);
    }
    return 'Unknown';
  }

  bool get hasValidQiblaData {
    return _qiblahDirection != null || _manualQiblaDirection != null;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _qiblaService.dispose();
    super.dispose();
  }
}
