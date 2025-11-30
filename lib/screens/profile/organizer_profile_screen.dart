import 'package:flutter/material.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class OrganizerProfileScreen extends StatefulWidget {
  const OrganizerProfileScreen({super.key});

  @override
  State<OrganizerProfileScreen> createState() => _OrganizerProfileScreenState();
}

class _OrganizerProfileScreenState extends State<OrganizerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Organizer',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Show menu options
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Profile Picture
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Name
            const Text(
              'Tamim Ikram',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Statistics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatItem(number: '3,583', label: 'Followers'),
                const SizedBox(width: 40),
                _StatItem(number: '167', label: 'Following'),
                const SizedBox(width: 40),
                _StatItem(number: '20', label: 'Events'),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  // Follow Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Follow'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Messages Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text('Messages'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE5D9),
                        foregroundColor: AppTheme.primaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryOrange,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: AppTheme.primaryOrange,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Events'),
                Tab(text: 'Reviews'),
              ],
            ),

            // Tab Content
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // About Tab
                  _AboutTab(
                    isExpanded: _isExpanded,
                    onToggleExpand: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                  // Events Tab
                  const _EventsTab(),
                  // Reviews Tab
                  const _ReviewsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _AboutTab extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const _AboutTab({
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    const fullText =
        'Ultricies arcu venenatis in lorem faucibus lobortis at. East odio varius nisl congue aliquam nunc est sit pull convallis magna. Est scelerisque dignissim non nibh arcu venenatis in lorem faucibus lobortis at. East odio varius nisl congue aliquam nunc est sit pull convallis magna. Est scelerisque dignissim non nibh arcu venenatis in lorem faucibus lobortis at. East odio varius nisl congue aliquam nunc est sit pull convallis magna.';

    const shortText =
        'Ultricies arcu venenatis in lorem faucibus lobortis at. East odio varius nisl congue aliquam nunc est sit pull convallis magna. Est scelerisque dignissim non nibh arcu venenatis in lorem faucibus lobortis at. East odio....';

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isExpanded ? fullText : shortText,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (!isExpanded)
            GestureDetector(
              onTap: onToggleExpand,
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Read More',
                  style: TextStyle(
                    color: AppTheme.primaryOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (isExpanded)
            GestureDetector(
              onTap: onToggleExpand,
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Read Less',
                  style: TextStyle(
                    color: AppTheme.primaryOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EventsTab extends StatelessWidget {
  const _EventsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No events yet',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_outline,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No reviews yet',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

