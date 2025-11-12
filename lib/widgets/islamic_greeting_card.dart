import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class IslamicGreetingCard extends StatelessWidget {
  const IslamicGreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final greeting = _getTimeBasedGreeting();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              greeting.icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting.arabicText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  greeting.englishText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    greeting.timeOfDay,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryPink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IslamicGreeting _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return IslamicGreeting(
        arabicText: 'صباح الخير',
        englishText: 'Good Morning - May Allah bless your day',
        timeOfDay: 'Morning',
        icon: Icons.wb_sunny,
      );
    } else if (hour >= 12 && hour < 17) {
      return IslamicGreeting(
        arabicText: 'ظهيرة مباركة',
        englishText: 'Blessed Afternoon - May Allah grant you success',
        timeOfDay: 'Afternoon',
        icon: Icons.wb_sunny_outlined,
      );
    } else if (hour >= 17 && hour < 20) {
      return IslamicGreeting(
        arabicText: 'مساء الخير',
        englishText: 'Good Evening - May Allah protect you',
        timeOfDay: 'Evening',
        icon: Icons.wb_twilight,
      );
    } else {
      return IslamicGreeting(
        arabicText: 'ليلة مباركة',
        englishText: 'Blessed Night - May Allah grant you peace',
        timeOfDay: 'Night',
        icon: Icons.nightlight_round,
      );
    }
  }
}

class IslamicGreeting {
  final String arabicText;
  final String englishText;
  final String timeOfDay;
  final IconData icon;

  IslamicGreeting({
    required this.arabicText,
    required this.englishText,
    required this.timeOfDay,
    required this.icon,
  });
}
