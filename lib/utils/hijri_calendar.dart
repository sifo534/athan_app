class HijriDate {
  final int day;
  final int month;
  final int year;
  final String monthName;

  HijriDate({
    required this.day,
    required this.month,
    required this.year,
    required this.monthName,
  });

  static const List<String> _monthNames = [
    'Muharram',
    'Safar',
    'Rabi\' al-awwal',
    'Rabi\' al-thani',
    'Jumada al-awwal',
    'Jumada al-thani',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah',
  ];

  static HijriDate fromGregorian(DateTime gregorianDate) {
    // Simple approximation for Hijri date conversion
    // In a real app, you would use a proper conversion algorithm
    
    final daysSinceEpoch = gregorianDate.difference(DateTime(622, 7, 16)).inDays;
    final hijriYear = ((daysSinceEpoch / 354.37) + 1).floor();
    
    // Approximate month and day calculation
    final dayOfYear = (daysSinceEpoch % 354.37).floor();
    final hijriMonth = ((dayOfYear / 29.5) + 1).floor().clamp(1, 12);
    final hijriDay = ((dayOfYear % 29.5) + 1).floor().clamp(1, 30);
    
    return HijriDate(
      day: hijriDay,
      month: hijriMonth,
      year: hijriYear,
      monthName: _monthNames[hijriMonth - 1],
    );
  }

  String get formattedDate => '$day $monthName $year AH';
  
  @override
  String toString() => formattedDate;
}
