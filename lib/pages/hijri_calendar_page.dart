import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../utils/hijri_calendar.dart';
import '../widgets/calendar_day_widget.dart';

class HijriCalendarPage extends StatefulWidget {
  const HijriCalendarPage({super.key});

  @override
  State<HijriCalendarPage> createState() => _HijriCalendarPageState();
}

class _HijriCalendarPageState extends State<HijriCalendarPage> {
  DateTime _selectedDate = DateTime.now();
  late HijriDate _currentHijriDate;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _currentHijriDate = HijriDate.fromGregorian(_selectedDate);
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
              _buildCalendarControls(),
              Expanded(
                child: _buildCalendar(),
              ),
              _buildIslamicEvents(),
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
                  Icons.calendar_month,
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
                      'Islamic Calendar',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Hijri calendar with Islamic events',
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
            child: Column(
              children: [
                Text(
                  _currentHijriDate.formattedDate,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: const Icon(Icons.chevron_left),
            color: AppColors.primaryPink,
          ),
          Text(
            '${_currentHijriDate.monthName} ${_currentHijriDate.year} AH',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.deepPurple,
            ),
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(Icons.chevron_right),
            color: AppColors.primaryPink,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(16),
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
          _buildWeekDaysHeader(),
          Expanded(
            child: _buildCalendarGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysHeader() {
    const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: weekDays.map((day) => Expanded(
          child: Center(
            child: Text(
              day,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final startDate = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));
    
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6 weeks
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final isCurrentMonth = date.month == _selectedDate.month;
        final isSelected = date.day == _selectedDate.day && 
                          date.month == _selectedDate.month &&
                          date.year == _selectedDate.year;
        final isToday = date.day == DateTime.now().day &&
                       date.month == DateTime.now().month &&
                       date.year == DateTime.now().year;
        
        return CalendarDayWidget(
          date: date,
          hijriDate: HijriDate.fromGregorian(date),
          isCurrentMonth: isCurrentMonth,
          isSelected: isSelected,
          isToday: isToday,
          hasEvent: _hasIslamicEvent(date),
          onTap: () => _selectDate(date),
        );
      },
    );
  }

  Widget _buildIslamicEvents() {
    final events = _getIslamicEventsForDate(_selectedDate);
    
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.islamicGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.islamicGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event,
                color: AppColors.islamicGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Islamic Events',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.islamicGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...events.map((event) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '• $event',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.islamicGreen,
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _currentHijriDate = HijriDate.fromGregorian(date);
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
      _currentHijriDate = HijriDate.fromGregorian(_selectedDate);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
      _currentHijriDate = HijriDate.fromGregorian(_selectedDate);
    });
  }

  bool _hasIslamicEvent(DateTime date) {
    return _getIslamicEventsForDate(date).isNotEmpty;
  }

  List<String> _getIslamicEventsForDate(DateTime date) {
    final hijriDate = HijriDate.fromGregorian(date);
    final events = <String>[];
    
    // Add some sample Islamic events
    if (hijriDate.month == 1 && hijriDate.day == 1) {
      events.add('Islamic New Year');
    }
    if (hijriDate.month == 1 && hijriDate.day == 10) {
      events.add('Day of Ashura');
    }
    if (hijriDate.month == 3 && hijriDate.day == 12) {
      events.add('Mawlid an-Nabi (Prophet\'s Birthday)');
    }
    if (hijriDate.month == 9) {
      events.add('Ramadan - Month of Fasting');
    }
    if (hijriDate.month == 10 && hijriDate.day == 1) {
      events.add('Eid al-Fitr');
    }
    if (hijriDate.month == 12 && hijriDate.day == 10) {
      events.add('Eid al-Adha');
    }
    
    return events;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
