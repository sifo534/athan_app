import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/tool_card.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildToolsGrid(context),
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Islamic Tools',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Helpful tools for your Islamic journey',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildToolsGrid(BuildContext context) {
    final tools = [
      ToolItem(
        title: 'Mosque Finder',
        subtitle: 'Find nearby mosques',
        icon: Icons.mosque,
        gradient: AppColors.primaryGradient,
        onTap: () => _showComingSoon(context, 'Mosque Finder'),
      ),
      ToolItem(
        title: 'Qibla Compass',
        subtitle: 'Get direction to Kaaba',
        icon: Icons.explore,
        gradient: const LinearGradient(
          colors: [AppColors.islamicGreen, AppColors.qiblaGreen],
        ),
        onTap: () => _navigateToQibla(context),
      ),
      ToolItem(
        title: 'Halal Finder',
        subtitle: 'Find halal restaurants',
        icon: Icons.restaurant,
        gradient: const LinearGradient(
          colors: [AppColors.islamicGold, Color(0xFFFF8F00)],
        ),
        onTap: () => _showComingSoon(context, 'Halal Finder'),
      ),
      ToolItem(
        title: 'Quran Player',
        subtitle: 'Listen to Quran recitation',
        icon: Icons.play_circle,
        gradient: const LinearGradient(
          colors: [AppColors.deepPurple, AppColors.darkPurple],
        ),
        onTap: () => _showComingSoon(context, 'Quran Player'),
      ),
      ToolItem(
        title: 'Prayer Tracker',
        subtitle: 'Track your daily prayers',
        icon: Icons.check_circle,
        gradient: const LinearGradient(
          colors: [AppColors.success, Color(0xFF2E7D32)],
        ),
        onTap: () => _showComingSoon(context, 'Prayer Tracker'),
      ),
      ToolItem(
        title: 'Dhikr Counter',
        subtitle: 'Count your dhikr',
        icon: Icons.fingerprint,
        gradient: AppColors.cardGradient,
        onTap: () => _showComingSoon(context, 'Dhikr Counter'),
      ),
      ToolItem(
        title: 'Islamic Calendar',
        subtitle: 'View Hijri calendar',
        icon: Icons.calendar_month,
        gradient: const LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
        ),
        onTap: () => _showComingSoon(context, 'Islamic Calendar'),
      ),
      ToolItem(
        title: 'Zakat Calculator',
        subtitle: 'Calculate your zakat',
        icon: Icons.calculate,
        gradient: const LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF00796B)],
        ),
        onTap: () => _showComingSoon(context, 'Zakat Calculator'),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        return ToolCard(tool: tools[index]);
      },
    );
  }

  void _navigateToQibla(BuildContext context) {
    // Navigate to Qibla tab
    // This would typically be handled by the parent navigation controller
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Switch to Qibla tab to use the compass'),
        backgroundColor: AppColors.islamicGreen,
      ),
    );
  }

  void _showComingSoon(BuildContext context, String toolName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.construction,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Coming Soon',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.deepPurple,
              ),
            ),
          ],
        ),
        content: Text(
          '$toolName is currently under development. Stay tuned for updates!',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: AppColors.primaryPink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  ToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}
