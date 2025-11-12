import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/theme_provider.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                _buildPrayerSettings(context),
                const SizedBox(height: 20),
                _buildAppearanceSettings(context),
                const SizedBox(height: 20),
                _buildNotificationSettings(context),
                const SizedBox(height: 20),
                _buildLocationSettings(context),
                const SizedBox(height: 20),
                _buildAboutSettings(context),
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
          'Settings',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Customize your Islamic companion',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerSettings(BuildContext context) {
    return SettingsSection(
      title: 'Prayer Settings',
      icon: Icons.mosque,
      children: [
        SettingsTile(
          title: 'Athan Voice',
          subtitle: 'Choose your preferred Athan reciter',
          leading: Icons.record_voice_over,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showAthanVoiceDialog(context),
        ),
        SettingsTile(
          title: 'Calculation Method',
          subtitle: 'Islamic Society of North America',
          leading: Icons.calculate,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showCalculationMethodDialog(context),
        ),
        SettingsTile(
          title: 'Prayer Notifications',
          subtitle: 'Get notified for prayer times',
          leading: Icons.notifications,
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primaryPink,
          ),
        ),
        SettingsTile(
          title: 'Silent Mode',
          subtitle: 'Auto-silence during prayer times',
          leading: Icons.volume_off,
          trailing: Switch(
            value: false,
            onChanged: (value) {},
            activeColor: AppColors.primaryPink,
          ),
        ),
      ],
    );
  }

  Widget _buildAppearanceSettings(BuildContext context) {
    return SettingsSection(
      title: 'Appearance',
      icon: Icons.palette,
      children: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return SettingsTile(
              title: 'Dark Mode',
              subtitle: 'Switch between light and dark theme',
              leading: Icons.dark_mode,
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
                activeColor: AppColors.primaryPink,
              ),
            );
          },
        ),
        SettingsTile(
          title: 'Language',
          subtitle: 'English',
          leading: Icons.language,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(context),
        ),
        SettingsTile(
          title: 'Font Size',
          subtitle: 'Medium',
          leading: Icons.text_fields,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showFontSizeDialog(context),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    return SettingsSection(
      title: 'Notifications',
      icon: Icons.notifications,
      children: [
        SettingsTile(
          title: 'Prayer Reminders',
          subtitle: 'Get reminded before prayer times',
          leading: Icons.alarm,
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primaryPink,
          ),
        ),
        SettingsTile(
          title: 'Reminder Time',
          subtitle: '10 minutes before',
          leading: Icons.schedule,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showReminderTimeDialog(context),
        ),
        SettingsTile(
          title: 'Daily Dhikr',
          subtitle: 'Daily remembrance notifications',
          leading: Icons.favorite,
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primaryPink,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSettings(BuildContext context) {
    return SettingsSection(
      title: 'Location',
      icon: Icons.location_on,
      children: [
        SettingsTile(
          title: 'Auto Location',
          subtitle: 'Automatically detect your location',
          leading: Icons.my_location,
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primaryPink,
          ),
        ),
        SettingsTile(
          title: 'Manual Location',
          subtitle: 'Set your location manually',
          leading: Icons.edit_location,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showManualLocationDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSettings(BuildContext context) {
    return SettingsSection(
      title: 'About',
      icon: Icons.info,
      children: [
        SettingsTile(
          title: 'App Version',
          subtitle: '1.0.0',
          leading: Icons.info_outline,
          onTap: () {},
        ),
        SettingsTile(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          leading: Icons.privacy_tip,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPrivacyPolicy(context),
        ),
        SettingsTile(
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          leading: Icons.description,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showTermsOfService(context),
        ),
        SettingsTile(
          title: 'Contact Us',
          subtitle: 'Get in touch with us',
          leading: Icons.contact_mail,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showContactDialog(context),
        ),
        SettingsTile(
          title: 'Rate App',
          subtitle: 'Rate us on the App Store',
          leading: Icons.star,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _rateApp(context),
        ),
      ],
    );
  }

  void _showAthanVoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Athan Voice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Abdul Basit',
            'Mishary Rashid',
            'Maher Al Mueaqly',
            'Abdullah Awad Al Juhany',
          ].map((voice) => RadioListTile<String>(
            title: Text(voice),
            value: voice,
            groupValue: 'Abdul Basit',
            onChanged: (value) => Navigator.pop(context),
            activeColor: AppColors.primaryPink,
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCalculationMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calculation Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Islamic Society of North America',
            'Muslim World League',
            'Egyptian General Authority',
            'Umm Al-Qura University',
            'University of Islamic Sciences, Karachi',
          ].map((method) => RadioListTile<String>(
            title: Text(method, style: const TextStyle(fontSize: 12)),
            value: method,
            groupValue: 'Islamic Society of North America',
            onChanged: (value) => Navigator.pop(context),
            activeColor: AppColors.primaryPink,
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'English',
            'العربية',
            'Français',
            'Español',
            'Türkçe',
          ].map((language) => RadioListTile<String>(
            title: Text(language),
            value: language,
            groupValue: 'English',
            onChanged: (value) => Navigator.pop(context),
            activeColor: AppColors.primaryPink,
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Small',
            'Medium',
            'Large',
            'Extra Large',
          ].map((size) => RadioListTile<String>(
            title: Text(size),
            value: size,
            groupValue: 'Medium',
            onChanged: (value) => Navigator.pop(context),
            activeColor: AppColors.primaryPink,
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showReminderTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            '5 minutes before',
            '10 minutes before',
            '15 minutes before',
            '30 minutes before',
          ].map((time) => RadioListTile<String>(
            title: Text(time),
            value: time,
            groupValue: '10 minutes before',
            onChanged: (value) => Navigator.pop(context),
            activeColor: AppColors.primaryPink,
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showManualLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Location'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter city name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    _showInfoDialog(context, 'Privacy Policy', 'Your privacy is important to us. This app collects location data to provide accurate prayer times and Qibla direction.');
  }

  void _showTermsOfService(BuildContext context) {
    _showInfoDialog(context, 'Terms of Service', 'By using this app, you agree to our terms of service. Please use this app responsibly.');
  }

  void _showContactDialog(BuildContext context) {
    _showInfoDialog(context, 'Contact Us', 'Email: support@athanmuslim.com\nWebsite: www.athanmuslim.com');
  }

  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
