import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_and_voucher/services/event_service.dart';
import 'package:event_and_voucher/models/event.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class EventsViewAllScreen extends StatefulWidget {
  const EventsViewAllScreen({super.key});

  @override
  State<EventsViewAllScreen> createState() => _EventsViewAllScreenState();
}

class _EventsViewAllScreenState extends State<EventsViewAllScreen> {
  String _selectedFilter = 'UPCOMING';
  final List<Event> _allEvents = EventService.getAllEvents();

  List<Event> get _filteredEvents {
    final now = DateTime.now();
    if (_selectedFilter == 'UPCOMING') {
      return _allEvents.where((event) => event.date.isAfter(now)).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } else {
      return _allEvents.where((event) => event.date.isBefore(now)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _filteredEvents;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Events',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Show search
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Show menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _FilterButton(
                    label: 'UPCOMING',
                    isSelected: _selectedFilter == 'UPCOMING',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'UPCOMING';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FilterButton(
                    label: 'PAST EVENTS',
                    isSelected: _selectedFilter == 'PAST EVENTS',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'PAST EVENTS';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Events List
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No ${_selectedFilter.toLowerCase()} events',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _EventCard(
                          event: event,
                          onTap: () => context.go('/event/${event.id}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE5D9) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppTheme.primaryOrange : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryOrange : Colors.grey.shade600,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const _EventCard({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format as "12-15 October, 22"
    final startDay = event.date.day.toString();
    final endDay = event.date.add(const Duration(days: 3)).day.toString();
    final month = DateFormat('MMMM').format(event.date);
    final year = DateFormat('yy').format(event.date);
    final dateRange = '$startDay-$endDay $month, $year';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: event.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.event, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                // Heart Icon
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Date and Location Row
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        dateRange,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Members Joined and Action Row
                  Row(
                    children: [
                      // Member Avatars
                      Stack(
                        children: [
                          _MemberAvatar(),
                          Positioned(
                            left: 20,
                            child: _MemberAvatar(),
                          ),
                          Positioned(
                            left: 40,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  '5k+',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Members joined',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      // Bookmark Icon
                      IconButton(
                        icon: Icon(
                          Icons.bookmark_border,
                          color: Colors.grey.shade600,
                          size: 24,
                        ),
                        onPressed: () {
                          // Bookmark action
                        },
                      ),
                      const SizedBox(width: 8),
                      // Join Now Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'JOIN NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade400,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(
        Icons.person,
        size: 16,
        color: Colors.grey.shade600,
      ),
    );
  }
}

