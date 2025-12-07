import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_and_voucher/services/event_service.dart';
import 'package:event_and_voucher/models/event.dart';
import 'package:event_and_voucher/theme/app_theme.dart';
import 'package:event_and_voucher/widgets/filter_bottom_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';
  FilterData _filters = FilterData();
  
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.category, 'color': Colors.blue},
    {'name': 'Design', 'icon': Icons.emoji_events, 'color': Colors.lightBlue},
    {'name': 'Art', 'icon': Icons.palette, 'color': AppTheme.primaryOrange},
    {'name': 'Sports', 'icon': Icons.sports_basketball, 'color': AppTheme.primaryOrange},
    {'name': 'Music', 'icon': Icons.music_note, 'color': Colors.red},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        initialFilters: _filters,
        onApply: (filters) {
          setState(() {
            _filters = filters;
          });
        },
      ),
    );
  }

  bool _matchesDateFilter(Event event) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(event.date.year, event.date.month, event.date.day);

    if (_filters.selectedDateOption == 'today') {
      return eventDate.isAtSameMomentAs(today);
    } else if (_filters.selectedDateOption == 'tomorrow') {
      final tomorrow = today.add(const Duration(days: 1));
      return eventDate.isAtSameMomentAs(tomorrow);
    } else if (_filters.selectedDateOption == 'this_week') {
      final endOfWeek = today.add(const Duration(days: 7));
      return eventDate.isAfter(today.subtract(const Duration(days: 1))) &&
          eventDate.isBefore(endOfWeek.add(const Duration(days: 1)));
    } else if (_filters.customDate != null) {
      final customDateOnly = DateTime(
        _filters.customDate!.year,
        _filters.customDate!.month,
        _filters.customDate!.day,
      );
      return eventDate.isAtSameMomentAs(customDateOnly);
    }

    return true; // No date filter applied
  }

  bool _matchesLocationFilter(Event event) {
    if (_filters.location == null || _filters.location!.isEmpty) return true;
    return event.location.toLowerCase().contains(_filters.location!.toLowerCase());
  }

  bool _matchesPriceFilter(Event event) {
    return event.price >= _filters.minPrice && event.price <= _filters.maxPrice;
  }

  bool _matchesCategoryFilter(Event event) {
    if (_filters.selectedCategories.isEmpty) return true;
    return _filters.selectedCategories.contains(event.category);
  }

  List<Event> get _filteredEvents {
    final allEvents = EventService.getAllEvents();
    var filtered = allEvents;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((event) {
        return event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event.category.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by category (from chips)
    if (_selectedCategory != 'All') {
      filtered = filtered.where((event) {
        return event.category.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    // Apply filter bottom sheet filters
    filtered = filtered.where((event) {
      return _matchesDateFilter(event) &&
          _matchesLocationFilter(event) &&
          _matchesPriceFilter(event) &&
          _matchesCategoryFilter(event);
    }).toList();

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _filteredEvents;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppTheme.textBlack),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  // Title
                  const Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // Search Bar and Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.grey2),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Find amazing events.',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color: AppTheme.white,
                      ),
                      onPressed: _showFilterBottomSheet,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Category Chips
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category['name'] == _selectedCategory;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _CategoryChip(
                      name: category['name'] as String,
                      icon: category['icon'] as IconData,
                      color: category['color'] as Color,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedCategory = category['name'] as String;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Event List
            Expanded(
              child: filteredEvents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No events found',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _SearchEventCard(event: event),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Category Chip Widget
class _CategoryChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.name,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppTheme.grey,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: color, width: 2)
              : Border.all(color: AppTheme.grey2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[700],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Search Event Card Widget
class _SearchEventCard extends StatelessWidget {
  final Event event;

  const _SearchEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM, yy');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/event/${event.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.grey2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
        children: [
          // Event Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: event.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: const Icon(Icons.event, color: Colors.white, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Event Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textBlack,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${dateFormat.format(event.date)} • ${event.location}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // JOIN NOW Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.textBlack,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'JOIN NOW',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${event.price.toStringAsFixed(0)}. USD',
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
          ),
        ),
      ),
    );
  }
}

