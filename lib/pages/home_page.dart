import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri.dart';
import '../constants/app_colors.dart';
import '../providers/prayer_times_provider.dart';
import '../widgets/prayer_time_card.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/islamic_greeting_card.dart';
import '../widgets/mosque_silhouette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrayerTimesProvider>().fetchPrayerTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => context.read<PrayerTimesProvider>().refreshPrayerTimes(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  const IslamicGreetingCard(),
                  const SizedBox(height: 20),
                  const NextPrayerCard(),
                  const SizedBox(height: 20),
                  _buildPrayerTimesSection(),
                  const SizedBox(height: 20),
                  _buildNewsSection(),
                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final hijriDate = HijriCalendar.fromDate(now);
    final gregorianDate = DateFormat('EEEE, MMMM d, y').format(now);
    
    return Consumer<PrayerTimesProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assalamu Alaikum',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (provider.currentCity.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            provider.currentCity,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                  ],
                ),
                IconButton(
                  onPressed: () => provider.refreshPrayerTimes(),
                  icon: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  color: AppColors.primaryPink,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPink.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    gregorianDate,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} AH',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrayerTimesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Prayer Times",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Consumer<PrayerTimesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.error != null) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error loading prayer times',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.error!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => provider.refreshPrayerTimes(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.prayerTimes == null) {
              return const Center(
                child: Text('No prayer times available'),
              );
            }

            final prayerTimesList = provider.prayerTimes!.getPrayerTimesList();
            return Column(
              children: prayerTimesList
                  .map((prayer) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PrayerTimeCard(prayerTime: prayer),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest News',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: AppColors.mosqueGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.deepPurple.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: MosqueSilhouette(),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Islamic News & Updates',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stay updated with the latest Islamic news and community events',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
