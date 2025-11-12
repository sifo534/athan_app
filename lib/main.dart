import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/app_theme.dart';
import 'constants/app_colors.dart';
import 'pages/home_page.dart';
import 'pages/qibla_page.dart';
import 'pages/tools_page.dart';
import 'pages/duas_page.dart';
import 'pages/settings_page.dart';
import 'pages/quran_page.dart';
import 'pages/hijri_calendar_page.dart';
import 'services/notification_service.dart';
import 'services/audio_service.dart';
import 'providers/theme_provider.dart';
import 'providers/prayer_times_provider.dart';
import 'providers/qibla_provider.dart';
import 'utils/navigation_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await NotificationService().initialize();
  await NotificationService().requestPermissions();
  await AudioService().initialize();
  
  runApp(const AthanMuslimApp());
}

class AthanMuslimApp extends StatelessWidget {
  const AthanMuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
        ChangeNotifierProvider(create: (_) => QiblaProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ScreenUtilInit(
            designSize: const Size(375, 812), // iPhone 12 Pro design size
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'Athan Muslim',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,
                home: const MainNavigationPage(),
              );
            },
          );
        },
      ),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigationPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late int _currentIndex;

  final List<Widget> _pages = [
    const HomePage(),
    const QiblaPage(),
    const ToolsPage(),
    const DuasPage(),
    const QuranPage(),
    const HijriCalendarPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    
    // Set up navigation callback
    NavigationHelper().setNavigationCallback((index) {
      if (mounted) {
        setState(() {
          _currentIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      drawer: _buildDrawer(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex.clamp(0, 4),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: 'Qibla',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps_rounded),
              label: 'Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Duas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.mosque,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Athan Muslim',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Your Islamic Companion',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home_rounded,
              title: 'Home',
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.explore_rounded,
              title: 'Qibla Compass',
              index: 1,
            ),
            _buildDrawerItem(
              icon: Icons.apps_rounded,
              title: 'Islamic Tools',
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.menu_book_rounded,
              title: 'Duas & Dhikr',
              index: 3,
            ),
            _buildDrawerItem(
              icon: Icons.book,
              title: 'Holy Quran',
              index: 4,
            ),
            _buildDrawerItem(
              icon: Icons.calendar_month,
              title: 'Hijri Calendar',
              index: 5,
            ),
            _buildDrawerItem(
              icon: Icons.settings_rounded,
              title: 'Settings',
              index: 6,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: isSelected ? AppColors.primaryGradient : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : null,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight: isSelected ? FontWeight.w600 : null,
          ),
        ),
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Athan Muslim'),
        content: const Text(
          'Athan Muslim is your complete Islamic companion app featuring prayer times, Qibla direction, Quran, Duas, and more.\n\nVersion 1.0.0\nDeveloped with ❤️ for the Muslim community.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
