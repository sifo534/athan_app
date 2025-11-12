import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/dua.dart';
import '../widgets/dua_card.dart';

class DuasPage extends StatefulWidget {
  const DuasPage({super.key});

  @override
  State<DuasPage> createState() => _DuasPageState();
}

class _DuasPageState extends State<DuasPage> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Daily',
    'Prayer',
    'Morning',
    'Evening',
    'Travel',
    'Food',
    'Protection',
  ];

  final List<Dua> _duas = [
    Dua(
      id: '1',
      title: 'Before Eating',
      arabicText: 'بِسْمِ اللهِ',
      transliteration: 'Bismillah',
      translation: 'In the name of Allah',
      category: 'Food',
      reference: 'Abu Dawud',
    ),
    Dua(
      id: '2',
      title: 'After Eating',
      arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
      transliteration: 'Alhamdulillahil-ladhi at\'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah',
      translation: 'Praise be to Allah Who has fed me this and provided it for me without any might or power on my part',
      category: 'Food',
      reference: 'Abu Dawud, At-Tirmidhi',
    ),
    Dua(
      id: '3',
      title: 'Morning Dhikr',
      arabicText: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ',
      transliteration: 'Asbahna wa asbahal-mulku lillah, walhamdulillah',
      translation: 'We have reached the morning and at this very time unto Allah belongs all sovereignty, and all praise is for Allah',
      category: 'Morning',
      reference: 'Muslim',
    ),
    Dua(
      id: '4',
      title: 'Evening Dhikr',
      arabicText: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ',
      transliteration: 'Amsayna wa amsal-mulku lillah, walhamdulillah',
      translation: 'We have reached the evening and at this very time unto Allah belongs all sovereignty, and all praise is for Allah',
      category: 'Evening',
      reference: 'Muslim',
    ),
    Dua(
      id: '5',
      title: 'Before Prayer',
      arabicText: 'اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ',
      transliteration: 'Allahumma ba\'id bayni wa bayna khatayaya kama ba\'adta baynal-mashriqi wal-maghrib',
      translation: 'O Allah, distance me from my sins just as You have distanced the East from the West',
      category: 'Prayer',
      reference: 'Bukhari, Muslim',
    ),
    Dua(
      id: '6',
      title: 'Travel Dua',
      arabicText: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ',
      transliteration: 'Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin',
      translation: 'Glory is to Him Who has subjected this to us, and we could never have it (by our efforts)',
      category: 'Travel',
      reference: 'Abu Dawud, At-Tirmidhi',
    ),
    Dua(
      id: '7',
      title: 'Protection from Evil',
      arabicText: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'A\'udhu bi kalimatillahit-tammati min sharri ma khalaq',
      translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created',
      category: 'Protection',
      reference: 'Muslim',
    ),
    Dua(
      id: '8',
      title: 'Daily Istighfar',
      arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
      transliteration: 'Astaghfirullaha-l\'azim alladhi la ilaha illa huwa-l hayya-l qayyumu wa atubu ilayh',
      translation: 'I seek forgiveness from Allah the Mighty, Whom there is none worthy of worship except Him, the Living, the Eternal, and I repent to Him',
      category: 'Daily',
      reference: 'Abu Dawud, At-Tirmidhi',
    ),
  ];

  List<Dua> get _filteredDuas {
    List<Dua> filtered = _duas;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((dua) => dua.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((dua) =>
          dua.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dua.transliteration.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dua.translation.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
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
              _buildSearchBar(),
              _buildCategoryFilter(),
              Expanded(
                child: _buildDuasList(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Islamic Duas',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daily supplications and remembrance',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
            hintText: 'Search duas...',
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
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primaryPink.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDuasList() {
    final filteredDuas = _filteredDuas;

    if (filteredDuas.isEmpty) {
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
              'No duas found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or category filter',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredDuas.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DuaCard(dua: filteredDuas[index]),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
