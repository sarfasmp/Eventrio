import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_and_voucher/models/notification.dart';
import 'package:event_and_voucher/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notifications data
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      userId: '1',
      userName: 'Micheal Ulasi',
      userImageUrl: 'https://i.pravatar.cc/150?img=12',
      type: NotificationType.following,
      message: 'started to following you',
      timestamp: DateTime.now(),
      isRead: false,
    ),
    AppNotification(
      id: '2',
      userId: '2',
      userName: 'David Silbia',
      userImageUrl: 'https://i.pravatar.cc/150?img=13',
      type: NotificationType.invite,
      message: 'invite you on Dribbble Design meetup 2022',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      isRead: false,
      eventId: '1',
      eventTitle: 'Dribbble Design meetup 2022',
    ),
    AppNotification(
      id: '3',
      userId: '1',
      userName: 'Micheal Ulasi',
      userImageUrl: 'https://i.pravatar.cc/150?img=12',
      type: NotificationType.comment,
      message: 'commented on your SAAS Mobile App...',
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      isRead: true,
    ),
    AppNotification(
      id: '4',
      userId: '3',
      userName: 'Jhon Wick',
      userImageUrl: 'https://i.pravatar.cc/150?img=14',
      type: NotificationType.invite,
      message: 'invite you on Basketball Final Match',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      eventId: '2',
      eventTitle: 'Basketball Final Match',
    ),
    AppNotification(
      id: '5',
      userId: '4',
      userName: 'Roman Kutepov',
      userImageUrl: 'https://i.pravatar.cc/150?img=15',
      type: NotificationType.like,
      message: 'liked your SAAS mobile app design',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      isRead: true,
    ),
  ];

  List<AppNotification> get unreadNotifications {
    final list = _notifications.where((n) => !n.isRead).toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  List<AppNotification> get yesterdayNotifications {
    // Get yesterday notifications that are already read (to avoid duplicates with unread)
    final list = _notifications.where((n) => n.isYesterday && n.isRead).toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = AppNotification(
          id: _notifications[index].id,
          userId: _notifications[index].userId,
          userName: _notifications[index].userName,
          userImageUrl: _notifications[index].userImageUrl,
          type: _notifications[index].type,
          message: _notifications[index].message,
          timestamp: _notifications[index].timestamp,
          isRead: true,
          eventId: _notifications[index].eventId,
          eventTitle: _notifications[index].eventTitle,
        );
      }
    });
  }

  void _handleAccept(String notificationId) {
    _markAsRead(notificationId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invitation accepted')),
    );
  }

  void _handleReject(String notificationId) {
    _markAsRead(notificationId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invitation rejected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unread = unreadNotifications;
    final yesterday = yesterdayNotifications;
    final hasNotifications = _notifications.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: AppTheme.textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textBlack),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.textBlack),
            onPressed: () {
              // TODO: Show menu
            },
          ),
        ],
      ),
      body: hasNotifications
          ? ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Unread Section
                if (unread.isNotEmpty) ...[
                  Row(
                    children: [
                      const Text(
                        'Unread',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textBlack,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${unread.length}',
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...unread.map((notification) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NotificationCard(
                          notification: notification,
                          onAccept: () => _handleAccept(notification.id),
                          onReject: () => _handleReject(notification.id),
                        ),
                      )),
                  const SizedBox(height: 24),
                ],

                // Yesterday Section
                if (yesterday.isNotEmpty) ...[
                  Row(
                    children: [
                      const Text(
                        'Yesterday',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textBlack,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${yesterday.length}',
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...yesterday.map((notification) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NotificationCard(
                          notification: notification,
                          onAccept: () => _handleAccept(notification.id),
                          onReject: () => _handleReject(notification.id),
                        ),
                      )),
                ],
              ],
            )
          : _EmptyState(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mailbox Illustration
            SizedBox(
              height: 250,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Ground line
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 250,
                      height: 3,
                      color: Colors.brown[400],
                    ),
                  ),
                  // Mailbox base (brown rectangular)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 140,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.brown[600],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Mailbox opening (semi-circular brown)
                  Positioned(
                    bottom: 30,
                    child: Container(
                      width: 100,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.brown[600],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  // Mailbox body (white rounded)
                  Positioned(
                    bottom: 45,
                    child: Container(
                      width: 120,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                      ),
                    ),
                  ),
                  // Cat peeking out from opening
                  Positioned(
                    bottom: 30,
                    child: SizedBox(
                      width: 70,
                      height: 60,
                      child: Stack(
                        children: [
                          // Cat tail (curved upward) - behind mailbox
                          Positioned(
                            bottom: 15,
                            right: -5,
                            child: Transform.rotate(
                              angle: -0.4,
                              child: Container(
                                width: 6,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryOrange,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                          // Cat body (orange, peeking from mailbox)
                          Positioned(
                            bottom: 0,
                            left: 15,
                            child: Container(
                              width: 40,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryOrange,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          // Cat face
                          Positioned(
                            top: 5,
                            left: 20,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  // Eyes
                                  Positioned(
                                    top: 7,
                                    left: 5,
                                    child: Container(
                                      width: 3,
                                      height: 3,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 7,
                                    right: 5,
                                    child: Container(
                                      width: 3,
                                      height: 3,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  // Smile
                                  Positioned(
                                    bottom: 5,
                                    left: 7,
                                    child: Container(
                                      width: 14,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border(
                                          bottom: BorderSide(color: Colors.black, width: 1.5),
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Whiskers
                                  Positioned(
                                    top: 11,
                                    left: -3,
                                    child: Container(
                                      width: 6,
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    top: 11,
                                    right: -3,
                                    child: Container(
                                      width: 6,
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Flag with "0" (on the right side)
                  Positioned(
                    top: 60,
                    right: 20,
                    child: Container(
                      width: 50,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryOrange,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '0',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Ups! There is no notification',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You\'ll be notified about activity on events you\'re a collaborator on.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const _NotificationCard({
    required this.notification,
    this.onAccept,
    this.onReject,
  });

  bool get hasActions => notification.type == NotificationType.invite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: notification.userImageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textBlack,
                        ),
                        children: [
                          TextSpan(
                            text: notification.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' ${notification.message}',
                          ),
                        ],
                      ),
                    ),
                    if (hasActions) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: onReject,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                side: BorderSide.none,
                                backgroundColor: AppTheme.primaryOrange.withValues(alpha: 0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(
                                  color: AppTheme.textBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onAccept,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                backgroundColor: AppTheme.primaryOrange,
                                foregroundColor: AppTheme.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Accept',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Timestamp
              Text(
                notification.timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

