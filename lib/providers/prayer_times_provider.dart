import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/prayer_times.dart';
import '../services/prayer_times_service.dart';
import '../services/location_service.dart';

class PrayerTimesProvider extends ChangeNotifier {
  PrayerTimes? _prayerTimes;
  Position? _currentPosition;
  bool _isLoading = false;
  String? _error;
  String _currentCity = '';
  
  final PrayerTimesService _prayerTimesService = PrayerTimesService();
  final LocationService _locationService = LocationService();
  
  PrayerTimes? get prayerTimes => _prayerTimes;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentCity => _currentCity;
  
  PrayerTimesProvider() {
    _initializePrayerTimes();
  }
  
  Future<void> _initializePrayerTimes() async {
    await fetchPrayerTimes();
  }
  
  Future<void> fetchPrayerTimes() async {
    _setLoading(true);
    _error = null;
    
    try {
      // Get current location
      _currentPosition = await _locationService.getCurrentLocation();
      
      if (_currentPosition != null) {
        // Get city name from coordinates
        _currentCity = await _locationService.getCityFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        
        // Fetch prayer times
        _prayerTimes = await _prayerTimesService.getPrayerTimes(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching prayer times: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> refreshPrayerTimes() async {
    await fetchPrayerTimes();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  String getNextPrayerName() {
    if (_prayerTimes == null) return '';
    
    final now = DateTime.now();
    final prayers = _prayerTimes!.getAllPrayerTimes();
    
    for (final prayer in prayers.entries) {
      if (prayer.value.isAfter(now)) {
        return prayer.key;
      }
    }
    
    return 'Fajr'; // Next day's Fajr
  }
  
  DateTime? getNextPrayerTime() {
    if (_prayerTimes == null) return null;
    
    final now = DateTime.now();
    final prayers = _prayerTimes!.getAllPrayerTimes();
    
    for (final prayer in prayers.entries) {
      if (prayer.value.isAfter(now)) {
        return prayer.value;
      }
    }
    
    // Return next day's Fajr
    final tomorrow = now.add(const Duration(days: 1));
    return DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      _prayerTimes!.fajr.hour,
      _prayerTimes!.fajr.minute,
    );
  }
  
  Duration? getTimeUntilNextPrayer() {
    final nextPrayerTime = getNextPrayerTime();
    if (nextPrayerTime == null) return null;
    
    final now = DateTime.now();
    return nextPrayerTime.difference(now);
  }
}
