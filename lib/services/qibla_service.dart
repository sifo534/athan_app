import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:sensors_plus/sensors_plus.dart';

class QiblaService {
  static final QiblaService _instance = QiblaService._internal();
  factory QiblaService() => _instance;
  QiblaService._internal();

  // Kaaba coordinates
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  Stream<QiblahDirection>? _qiblahStream;
  bool _isInitialized = false;

  Future<bool> initialize() async {
    try {
      // Check if device supports sensors
      final isSupported = await FlutterQiblah.androidDeviceSensorSupport();
      if (isSupported != null && isSupported) {
        _qiblahStream = FlutterQiblah.qiblahStream;
        _isInitialized = true;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error initializing Qibla service: $e');
      return false;
    }
  }

  Stream<QiblahDirection>? get qiblahStream => _qiblahStream;
  bool get isInitialized => _isInitialized;

  // Calculate Qibla direction manually if needed
  Future<double> calculateQiblaDirection(Position position) async {
    try {
      final lat1 = _degreesToRadians(position.latitude);
      final lon1 = _degreesToRadians(position.longitude);
      final lat2 = _degreesToRadians(kaabaLatitude);
      final lon2 = _degreesToRadians(kaabaLongitude);

      final deltaLon = lon2 - lon1;

      final y = math.sin(deltaLon) * math.cos(lat2);
      final x = math.cos(lat1) * math.sin(lat2) - 
                math.sin(lat1) * math.cos(lat2) * math.cos(deltaLon);

      final bearing = math.atan2(y, x);
      final qiblaDirection = (_radiansToDegrees(bearing) + 360) % 360;

      return qiblaDirection;
    } catch (e) {
      debugPrint('Error calculating Qibla direction: $e');
      return 0.0;
    }
  }

  // Calculate distance to Kaaba
  double calculateDistanceToKaaba(Position position) {
    return Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      kaabaLatitude,
      kaabaLongitude,
    );
  }

  // Get compass heading from device sensors
  Stream<double> getCompassHeading() {
    return magnetometerEventStream().map((MagnetometerEvent event) {
      // Calculate heading from magnetometer data
      final heading = math.atan2(event.y, event.x) * (180 / math.pi);
      return (heading + 360) % 360;
    });
  }

  // Helper methods
  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  double _radiansToDegrees(double radians) {
    return radians * (180 / math.pi);
  }

  // Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toInt()} m';
    } else {
      final km = distanceInMeters / 1000;
      if (km < 100) {
        return '${km.toStringAsFixed(1)} km';
      } else {
        return '${km.toInt()} km';
      }
    }
  }

  // Get direction name from degrees
  String getDirectionName(double degrees) {
    const directions = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'
    ];
    
    final index = ((degrees + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  void dispose() {
    _qiblahStream = null;
    _isInitialized = false;
  }
}
