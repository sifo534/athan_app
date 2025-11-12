import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/hijri_calendar.dart';

class CalendarDayWidget extends StatelessWidget {
  final DateTime date;
  final HijriDate hijriDate;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final bool hasEvent;
  final VoidCallback onTap;

  const CalendarDayWidget({
    super.key,
    required this.date,
    required this.hijriDate,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.hasEvent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected 
              ? null 
              : isToday 
                  ? AppColors.islamicGold.withOpacity(0.2)
                  : null,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.islamicGold, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gregorian date
            Text(
              date.day.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : isCurrentMonth
                        ? Theme.of(context).textTheme.bodyMedium?.color
                        : AppColors.textHint,
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            
            // Hijri date (smaller)
            Text(
              hijriDate.day.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : isCurrentMonth
                        ? AppColors.textSecondary
                        : AppColors.textHint,
                fontSize: 10,
              ),
            ),
            
            // Event indicator
            if (hasEvent)
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white 
                      : AppColors.islamicGreen,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
