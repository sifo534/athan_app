class PrayerTimes {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime date;
  
  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });
  
  factory PrayerTimes.fromJson(Map<String, dynamic> json, DateTime date) {
    final timings = json['data']['timings'] as Map<String, dynamic>;
    
    return PrayerTimes(
      fajr: _parseTime(timings['Fajr'], date),
      sunrise: _parseTime(timings['Sunrise'], date),
      dhuhr: _parseTime(timings['Dhuhr'], date),
      asr: _parseTime(timings['Asr'], date),
      maghrib: _parseTime(timings['Maghrib'], date),
      isha: _parseTime(timings['Isha'], date),
      date: date,
    );
  }
  
  static DateTime _parseTime(String timeString, DateTime date) {
    // Remove timezone info and extra characters
    final cleanTime = timeString.split(' ')[0];
    final parts = cleanTime.split(':');
    
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
  
  Map<String, DateTime> getAllPrayerTimes() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };
  }
  
  List<PrayerTimeItem> getPrayerTimesList() {
    return [
      PrayerTimeItem(name: 'Fajr', time: fajr, icon: '🌅'),
      PrayerTimeItem(name: 'Sunrise', time: sunrise, icon: '☀️'),
      PrayerTimeItem(name: 'Dhuhr', time: dhuhr, icon: '🌞'),
      PrayerTimeItem(name: 'Asr', time: asr, icon: '🌇'),
      PrayerTimeItem(name: 'Maghrib', time: maghrib, icon: '🌆'),
      PrayerTimeItem(name: 'Isha', time: isha, icon: '🌙'),
    ];
  }
}

class PrayerTimeItem {
  final String name;
  final DateTime time;
  final String icon;
  
  PrayerTimeItem({
    required this.name,
    required this.time,
    required this.icon,
  });
  
  String get formattedTime {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final displayHour = hour == 0 ? 12 : hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    
    return '$displayHour:$minute $period';
  }
}
