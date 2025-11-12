import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/surah.dart';
import '../widgets/surah_card.dart';
import '../services/audio_service.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isArabicOrder = true;

  final List<Surah> _surahs = [
    Surah(number: 1, name: 'Al-Fatihah', arabicName: 'الفاتحة', verses: 7, revelationType: 'Meccan'),
    Surah(number: 2, name: 'Al-Baqarah', arabicName: 'البقرة', verses: 286, revelationType: 'Medinan'),
    Surah(number: 3, name: 'Ali \'Imran', arabicName: 'آل عمران', verses: 200, revelationType: 'Medinan'),
    Surah(number: 4, name: 'An-Nisa', arabicName: 'النساء', verses: 176, revelationType: 'Medinan'),
    Surah(number: 5, name: 'Al-Ma\'idah', arabicName: 'المائدة', verses: 120, revelationType: 'Medinan'),
    Surah(number: 6, name: 'Al-An\'am', arabicName: 'الأنعام', verses: 165, revelationType: 'Meccan'),
    Surah(number: 7, name: 'Al-A\'raf', arabicName: 'الأعراف', verses: 206, revelationType: 'Meccan'),
    Surah(number: 8, name: 'Al-Anfal', arabicName: 'الأنفال', verses: 75, revelationType: 'Medinan'),
    Surah(number: 9, name: 'At-Tawbah', arabicName: 'التوبة', verses: 129, revelationType: 'Medinan'),
    Surah(number: 10, name: 'Yunus', arabicName: 'يونس', verses: 109, revelationType: 'Meccan'),
    // Add more surahs as needed...
    Surah(number: 67, name: 'Al-Mulk', arabicName: 'الملك', verses: 30, revelationType: 'Meccan'),
    Surah(number: 112, name: 'Al-Ikhlas', arabicName: 'الإخلاص', verses: 4, revelationType: 'Meccan'),
    Surah(number: 113, name: 'Al-Falaq', arabicName: 'الفلق', verses: 5, revelationType: 'Meccan'),
    Surah(number: 114, name: 'An-Nas', arabicName: 'الناس', verses: 6, revelationType: 'Meccan'),
  ];

  List<Surah> get _filteredSurahs {
    List<Surah> filtered = List.from(_surahs);

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((surah) =>
          surah.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          surah.arabicName.contains(_searchQuery) ||
          surah.number.toString().contains(_searchQuery)).toList();
    }

    // Sort by order preference
    if (_isArabicOrder) {
      filtered.sort((a, b) => a.number.compareTo(b.number));
    } else {
      // Sort by revelation order (simplified)
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    return filtered;
  }

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
              _buildSearchAndFilter(),
              Expanded(
                child: _buildSurahsList(),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Holy Quran',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Read and listen to the Quran',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.mosqueGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_stories,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Continue Reading',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Surah Al-Fatihah - Verse 1',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search surahs...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter toggle
          Row(
            children: [
              Text(
                'Sort by:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    _buildFilterChip('Mushaf Order', _isArabicOrder, () {
                      setState(() {
                        _isArabicOrder = true;
                      });
                    }),
                    const SizedBox(width: 8),
                    _buildFilterChip('Alphabetical', !_isArabicOrder, () {
                      setState(() {
                        _isArabicOrder = false;
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: AppColors.textHint),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSurahsList() {
    final filteredSurahs = _filteredSurahs;

    if (filteredSurahs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No surahs found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredSurahs.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SurahCard(
            surah: filteredSurahs[index],
            onTap: () => _openSurah(filteredSurahs[index]),
            onPlayTap: () => _playSurah(filteredSurahs[index]),
          ),
        );
      },
    );
  }

  void _openSurah(Surah surah) {
    // Navigate to surah reading page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahReadingPage(surah: surah),
      ),
    );
  }

  void _playSurah(Surah surah) {
    // Play surah audio
    AudioService().playQuranRecitation(
      surah: surah.name,
      reciter: 'abdul_basit',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing ${surah.name}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Placeholder for surah reading page
class SurahReadingPage extends StatelessWidget {
  final Surah surah;

  const SurahReadingPage({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surah.name),
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              surah.arabicName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              surah.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${surah.verses} verses • ${surah.revelationType}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Surah reading interface coming soon...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
