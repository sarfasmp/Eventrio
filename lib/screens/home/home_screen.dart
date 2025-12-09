import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:event_and_voucher/theme/app_theme.dart';
import 'package:event_and_voucher/widgets/app_drawer.dart';
import 'package:event_and_voucher/providers/drawer_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Set the scaffold key in the provider after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(drawerProvider.notifier).setScaffoldKey(_scaffoldKey);
    });
  }

  int _getCurrentIndex(String location) {
    if (location == '/') return 0;
    if (location == '/vouchers') return 1;
    if (location == '/cart') return 2;
    if (location == '/profile') return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _getCurrentIndex(location);

    void onItemTapped(int index) {
      switch (index) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/vouchers');
          break;
        case 2:
          context.go('/cart');
          break;
        case 3:
          context.go('/profile');
          break;
      }
    }

    // Show FAB only on events screen
    final showFAB = location == '/' || location.startsWith('/event');

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const AppDrawer(),
      body: widget.child,
      floatingActionButton: showFAB
          ? FloatingActionButton(
              onPressed: () {
                context.push('/events/create');
              },
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: AppTheme.white,
              elevation: 4,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNavItem(
                  icon: Icons.home,
                  isSelected: currentIndex == 0,
                  onTap: () => onItemTapped(0),
                ),
                _BottomNavItem(
                  icon: Icons.calendar_today,
                  isSelected: currentIndex == 1,
                  onTap: () => onItemTapped(1),
                ),
                _BottomNavItem(
                  icon: Icons.location_on,
                  isSelected: currentIndex == 2,
                  onTap: () => onItemTapped(2),
                ),
                _BottomNavItem(
                  icon: Icons.person,
                  isSelected: currentIndex == 3,
                  onTap:  () => onItemTapped(3)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: isSelected ? AppTheme.primaryOrange : Colors.grey.shade600,
        size: 24,
      ),
    );
  }
}
