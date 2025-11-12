import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/prayer_times_provider.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: FutureBuilder(
                  future: FlutterQiblah.androidDeviceSensorSupport(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return _buildErrorWidget('Error checking device support');
                    }

                    if (snapshot.data == true) {
                      return _buildQiblaCompass();
                    } else {
                      return _buildUnsupportedDevice();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Qibla Compass',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Point your device towards the Kaaba',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Consumer<PrayerTimesProvider>(
            builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.islamicGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.islamicGreen.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.islamicGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      provider.currentCity.isNotEmpty 
                          ? provider.currentCity 
                          : 'Getting location...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.islamicGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQiblaCompass() {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorWidget('Error getting Qibla direction');
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) {
          return _buildErrorWidget('Unable to get Qibla direction');
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCompass(qiblahDirection),
            const SizedBox(height: 32),
            _buildDirectionInfo(qiblahDirection),
            const SizedBox(height: 32),
            _buildInstructions(),
          ],
        );
      },
    );
  }

  Widget _buildCompass(QiblahDirection qiblahDirection) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Compass background
          Container(
            width: 280,
            height: 280,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Stack(
              children: [
                // Compass markings
                ...List.generate(36, (index) {
                  final angle = index * 10.0;
                  final isMainDirection = angle % 90 == 0;
                  return Transform.rotate(
                    angle: angle * (3.14159 / 180),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: isMainDirection ? 3 : 1,
                        height: isMainDirection ? 30 : 15,
                        margin: const EdgeInsets.only(top: 10),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }),
                // Direction labels
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Text(
                    'N',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Qibla indicator
          Transform.rotate(
            angle: qiblahDirection.qiblah * (3.14159 / 180),
            child: Container(
              width: 4,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.islamicGreen,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Center circle with Kaaba icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.islamicGold,
              boxShadow: [
                BoxShadow(
                  color: AppColors.islamicGold.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.place,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionInfo(QiblahDirection qiblahDirection) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Column(
        children: [
          Text(
            'Qibla Direction',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.deepPurple,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(
                'Direction',
                '${qiblahDirection.qiblah.toInt()}°',
                Icons.explore,
              ),
              _buildInfoItem(
                'Offset',
                '${qiblahDirection.offset.toInt()}°',
                Icons.navigation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryPink,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.deepPurple,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.islamicGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.islamicGreen.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.islamicGreen,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            'Instructions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.islamicGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '• Hold your device flat\n• Turn until the green line points up\n• Face the direction of the green line',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.islamicGreen,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.error.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Qibla Compass Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsupportedDevice() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.warning.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.phone_android,
              color: AppColors.warning,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Device Not Supported',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your device does not support compass functionality required for Qibla direction.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.warning,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
