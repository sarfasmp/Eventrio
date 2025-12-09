import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:event_and_voucher/providers/auth_provider.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      // Drawer from right side
      semanticLabel: 'Navigation drawer',
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryOrange,
              AppTheme.secondaryDarkOrange,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Curved geometric shapes background
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondaryDarkOrange.withValues(alpha: 0.4),
                ),
              ),
            ),
            Positioned(
              top: 120,
              left: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: -60,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondaryDarkOrange.withValues(alpha: 0.35),
                ),
              ),
            ),
            Positioned(
              top: 300,
              right: 20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryOrange.withValues(alpha: 0.25),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: AppTheme.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                  // Header Row with Profile and Close Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryOrange,
                              width: 3,
                            ),
                            color: Colors.transparent,
                          ),
                          child: ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.white.withValues(alpha: 0.15),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name and Email
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'MD Rafi Islam',
                                style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'rafiislamapon4@gmail.com',
                                style: TextStyle(
                                  color: AppTheme.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Menu Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _DrawerMenuItem(
                          icon: Icons.person,
                          title: 'My Profile',
                          onTap: () {
                            Navigator.pop(context);
                            context.push('/profile');
                          },
                        ),
                        _DrawerMenuItem(
                          icon: Icons.message,
                          title: 'Massage',
                          badge: '3',
                          badgeColor: Colors.red,
                          onTap: () {
                            Navigator.pop(context);
                            context.push('/notifications');
                          },
                        ),
                        _DrawerMenuItem(
                          icon: Icons.calendar_today,
                          title: 'Calender',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to calendar
                          },
                        ),
                        _DrawerMenuItem(
                          icon: Icons.bookmark,
                          title: 'Bookmark',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to bookmarks
                          },
                        ),
                        _DrawerMenuItem(
                          icon: Icons.mail,
                          title: 'Contact Us',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to contact
                          },
                        ),
                        _DrawerMenuItem(
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to settings
                          },
                        ),
                        _DrawerMenuItem(
                          icon: Icons.help_outline,
                          title: 'Helps & FAQs',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to help
                          },
                        ),
                        const SizedBox(height: 20),
                        _DrawerMenuItem(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          onTap: () {
                            Navigator.pop(context);
                            ref.read(authProvider.notifier).logout();
                            context.go('/splash');
                          },
                        ),
                      ],
                    ),
                  ),

                  // Upgrade Pro Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: AppTheme.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Upgrade Pro',
                            style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    this.badge,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 55),
            Icon(
              icon,
              color: AppTheme.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTheme.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (badge != null)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: badgeColor ?? AppTheme.primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

