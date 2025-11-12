import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../models/prayer_times.dart';

class PrayerTimeCard extends StatelessWidget {
  final PrayerTimeItem prayerTime;

  const PrayerTimeCard({
    super.key,
    required this.prayerTime,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrentPrayer = _isCurrentPrayer(now);
    final isPassed = prayerTime.time.isBefore(now);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: isCurrentPrayer 
            ? AppColors.primaryGradient 
            : null,
        color: isCurrentPrayer 
            ? null 
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isCurrentPrayer 
                ? AppColors.primaryPink.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: isCurrentPrayer 
                  ? Colors.white.withOpacity(0.2)
                  : AppColors.primaryPink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                prayerTime.icon,
                style: TextStyle(fontSize: 24.sp),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayerTime.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isCurrentPrayer 
                        ? Colors.white 
                        : Theme.of(context).textTheme.titleMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  prayerTime.formattedTime,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isCurrentPrayer 
                        ? Colors.white.withOpacity(0.9)
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentPrayer)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Now',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else if (isPassed)
            Icon(
              Icons.check_circle,
              color: AppColors.success.withOpacity(0.7),
              size: 20,
            )
          else
            Icon(
              Icons.schedule,
              color: AppColors.textSecondary,
              size: 20,
            ),
        ],
      ),
    );
  }

  bool _isCurrentPrayer(DateTime now) {
    // Check if this is the current prayer time (within the prayer window)
    final prayers = [
      'Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'
    ];
    
    final currentIndex = prayers.indexOf(prayerTime.name);
    if (currentIndex == -1) return false;
    
    // Simple logic: if current time is after this prayer but before next prayer
    if (prayerTime.time.isBefore(now)) {
      // Check if it's before the next prayer (simplified)
      final nextHour = prayerTime.time.add(const Duration(hours: 1));
      return now.isBefore(nextHour);
    }
    
    return false;
  }
}
