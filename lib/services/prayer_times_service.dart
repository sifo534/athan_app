import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_times.dart';

class PrayerTimesService {
  static const String _baseUrl = 'http://api.aladhan.com/v1';
  
  Future<PrayerTimes> getPrayerTimes(double latitude, double longitude) async {
    try {
      final now = DateTime.now();
      final url = Uri.parse(
        '$_baseUrl/timings/${now.day}-${now.month}-${now.year}?latitude=$latitude&longitude=$longitude&method=2'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PrayerTimes.fromJson(jsonData, now);
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }
  
  Future<PrayerTimes> getPrayerTimesForDate(
    double latitude, 
    double longitude, 
    DateTime date
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/timings/${date.day}-${date.month}-${date.year}?latitude=$latitude&longitude=$longitude&method=2'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PrayerTimes.fromJson(jsonData, date);
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }
  
  Future<List<PrayerTimes>> getPrayerTimesForMonth(
    double latitude, 
    double longitude, 
    int month, 
    int year
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/calendar/$month/$year?latitude=$latitude&longitude=$longitude&method=2'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        
        return data.map((dayData) {
          final dateString = dayData['date']['gregorian']['date'];
          final dateParts = dateString.split('-');
          final date = DateTime(
            int.parse(dateParts[2]),
            int.parse(dateParts[1]),
            int.parse(dateParts[0]),
          );
          
          return PrayerTimes.fromJson({'data': dayData}, date);
        }).toList();
      } else {
        throw Exception('Failed to load monthly prayer times: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching monthly prayer times: $e');
    }
  }
}
